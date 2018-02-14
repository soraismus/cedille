{-# OPTIONS --type-in-type #-}
open import Cast
open ι
module Examples
  (Nat : ⋆)
  (List : ⋆ → ⋆)
  (len : {A : ⋆} → List A → Nat)
  (plus : Nat → Nat → Nat)
  (Vec : ⋆ → Nat → ⋆)
  (v2l : {A : ⋆} {n : Nat} → Cast' (Vec A n) (List A))
  (v2l-pres : {A : ⋆} {n : Nat} (xs : Vec A n) → n ≅ len (cast' v2l xs))
  (l2v : {A : ⋆} → Cast (List A) (λ xs → Vec A (len xs)))
  (l2vC : {A : ⋆} {n : Nat} → Cast (List A) (λ xs → (len xs ≅ n) → Vec A n))
  (v2u : {A : ⋆} {n : Nat} → Cast' (Vec A n) (ι (List A) λ xs → n ≅ len xs))
  (u2v : {A : ⋆} {n : Nat} → Cast' (ι (List A) λ xs → n ≅ len xs) (Vec A n))
  where

VecL : ⋆ → Nat → ⋆
VecL A n = ι (List A) λ xs → n ≅ len xs

appendV2appendL : Cast'
  ({A : ⋆} {n : Nat} → Vec A n → {m : Nat} → Vec A m → Vec A (plus n m))
  ({A : ⋆} → List A → List A → List A)
appendV2appendL =
  copyType λ A →
  allArr2arr l2v λ n →
  allArr2arr l2v λ m →
  v2l

assocV2assocL :
  {appendV : {A : ⋆} {n : Nat} → Vec A n → {m : Nat} → Vec A m → Vec A (plus n m)}
  → let appendL = cast' appendV2appendL appendV in
  Cast'
   ({A : ⋆}
    {n : Nat} (xs : Vec A n)
    {m : Nat} (ys : Vec A m)
    {o : Nat} (zs : Vec A o)
    → appendV (appendV xs ys) zs ≅ appendV xs (appendV ys zs))
   ({A : ⋆}
    (xs : List A)
    (ys : List A)
    (zs : List A)
    → appendL (appendL xs ys) zs ≅ appendL xs (appendL ys zs))
assocV2assocL =
  copyType λ A →
  allPi2Pi l2v λ xs →
  allPi2Pi l2v λ ys →
  allPi2Pi l2v λ zs →
  trust -- would be id if agda had untyped equality & casts

appendL2appendV : Cast'
  ({A : ⋆} (xs ys : List A) → VecL A (plus (len xs) (len ys)))
  ({A : ⋆} {n : Nat} → Vec A n → {m : Nat} → Vec A m → Vec A (plus n m))
appendL2appendV =
  copyType λ A →
  pi2allArr v2u λ xs →
  pi2allArr v2u λ ys →
  u2v

appendL2appendVC : Cast
  ({A : ⋆} → List A → List A → List A)
  (λ f → ({A : ⋆} (xs ys : List A) → len (f xs ys) ≅ plus (len xs) (len ys)) →
  {A : ⋆} {n : Nat} → Vec A n → {m : Nat} → Vec A m → Vec A (plus n m))
appendL2appendVC =
  copyTypeC λ A →
  arr2allArrC v2l v2l-pres λ xs →
  arr2allArrC v2l v2l-pres λ ys →
  l2vC

assocL2assocV :
  {appendL : {A : ⋆} (xs ys : List A) → VecL A (plus (len xs) (len ys))}
  → let appendV = cast' appendL2appendV appendL in
  Cast'
   ({A : ⋆}
    (xs : List A)
    (ys : List A)
    (zs : List A)
    → appendL (π₁ (appendL xs ys)) zs ≅ appendL xs (π₁ (appendL ys zs)))
   ({A : ⋆}
    {n : Nat} (xs : Vec A n)
    {m : Nat} (ys : Vec A m)
    {o : Nat} (zs : Vec A o)
    → appendV (appendV xs ys) zs ≅ appendV xs (appendV ys zs))
assocL2assocV =
  copyType λ A →
  pi2allPi l2v v2u λ xs →
  pi2allPi l2v v2u λ ys →
  pi2allPi l2v v2u λ zs →
  trust -- would be id if agda had untyped equality & casts

mapL2mapV : Cast'
  ({A B : ⋆} (f : A → B) (xs : List A) → VecL B (len xs))
  ({A B : ⋆} (f : A → B) {n : Nat} (xs : Vec A n) → Vec B n)
mapL2mapV =
  copyType λ A →
  copyType λ B →
  copyArr λ f →
  pi2allArr v2u λ xs →
  u2v