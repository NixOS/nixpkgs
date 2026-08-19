{ mkDerivation, array, base, binary, bytestring, containers
, deepseq, directory, fetchzip, filepath, ghc-prim, lib, QuickCheck
, system-cxx-std-lib, tasty, tasty-bench, tasty-hunit
, tasty-inspection-testing, tasty-quickcheck, template-haskell
, temporary, transformers
}:
mkDerivation {
  pname = "text";
  version = "2.1.3";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/text-2.1.3/text-2.1.3.tar.gz";
    sha256 = "1wwbsjp63s0g0cb57rrgracvkjnsymcjsxwgfm6waw3dgczi3qpc";
  };
  libraryHaskellDepends = [
    array base binary bytestring deepseq ghc-prim system-cxx-std-lib
    template-haskell
  ];
  testHaskellDepends = [
    base binary bytestring deepseq ghc-prim QuickCheck tasty
    tasty-hunit tasty-inspection-testing tasty-quickcheck
    template-haskell temporary transformers
  ];
  benchmarkHaskellDepends = [
    base bytestring containers deepseq directory filepath tasty-bench
    temporary transformers
  ];
  doCheck = false;
  homepage = "https://github.com/haskell/text";
  description = "An efficient packed Unicode text type";
  license = lib.meta.getLicenseFromSpdxId "BSD-2-Clause";
}
