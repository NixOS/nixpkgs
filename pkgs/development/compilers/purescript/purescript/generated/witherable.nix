{ mkDerivation, base, base-orphans, containers, hashable
, indexed-traversable, indexed-traversable-instances, lib
, QuickCheck, quickcheck-instances, tasty, tasty-quickcheck
, transformers, unordered-containers, vector
}:
mkDerivation {
  pname = "witherable";
  version = "0.4.1";
  sha256 = "0b153f0632af584bb43b97627d2d512e054ac30f3b5b3de1d842a9d6006e42ca";
  revision = "1";
  editedCabalFile = "02l2gbcab7w72hqlbs1ikylgb1970a0iyrikn847nncivbzrc3gj";
  libraryHaskellDepends = [
    base base-orphans containers hashable indexed-traversable
    indexed-traversable-instances transformers unordered-containers
    vector
  ];
  testHaskellDepends = [
    base containers hashable QuickCheck quickcheck-instances tasty
    tasty-quickcheck transformers unordered-containers vector
  ];
  homepage = "https://github.com/fumieval/witherable";
  description = "filterable traversable";
  license = lib.licenses.bsd3;
}
