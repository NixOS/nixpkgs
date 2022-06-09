{ mkDerivation, base, base-orphans, deepseq, doctest, ghc-prim
, HUnit, lib, primitive, QuickCheck, random, tasty, tasty-hunit
, tasty-quickcheck, template-haskell, transformers
}:
mkDerivation {
  pname = "vector";
  version = "0.12.3.1";
  sha256 = "fb4a53c02bd4d7fdf155c0604da9a5bb0f3b3bfce5d9960aea11c2ae235b9f35";
  revision = "2";
  editedCabalFile = "0gkzrqcx5fymkxm92gy47qj0spj79ygv1vn7kfzdg7nn284x1yzz";
  libraryHaskellDepends = [ base deepseq ghc-prim primitive ];
  testHaskellDepends = [
    base base-orphans doctest HUnit primitive QuickCheck random tasty
    tasty-hunit tasty-quickcheck template-haskell transformers
  ];
  homepage = "https://github.com/haskell/vector";
  description = "Efficient Arrays";
  license = lib.licenses.bsd3;
}
