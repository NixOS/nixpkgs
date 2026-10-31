{
  mkDerivation,
  base,
  bytestring,
  deepseq,
  exceptions,
  fetchzip,
  generic-deriving,
  generic-random,
  lib,
  os-string,
  quickcheck-classes-base,
  tasty,
  tasty-bench,
  tasty-quickcheck,
  template-haskell,
}:
mkDerivation {
  pname = "filepath";
  version = "1.5.4.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/filepath-1.5.4.0/filepath-1.5.4.0.tar.gz";
    sha256 = "0g7waql8r1lla68vd25zkr5pb58glzl3rpqjydv38f9px7fsk861";
  };
  libraryHaskellDepends = [
    base
    bytestring
    deepseq
    exceptions
    os-string
    template-haskell
  ];
  testHaskellDepends = [
    base
    bytestring
    deepseq
    generic-deriving
    generic-random
    os-string
    quickcheck-classes-base
    tasty
    tasty-quickcheck
  ];
  benchmarkHaskellDepends = [
    base
    bytestring
    deepseq
    os-string
    tasty-bench
  ];
  homepage = "https://github.com/haskell/filepath/blob/master/README.md";
  description = "Library for manipulating FilePaths in a cross platform way";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
