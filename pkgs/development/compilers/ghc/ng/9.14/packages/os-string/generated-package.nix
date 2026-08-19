{ mkDerivation, base, bytestring, deepseq, exceptions, fetchzip
, lib, QuickCheck, quickcheck-classes-base, random, tasty-bench
, template-haskell
}:
mkDerivation {
  pname = "os-string";
  version = "2.0.8";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/os-string-2.0.8/os-string-2.0.8.tar.gz";
    sha256 = "1i3qmgqa2wyri8fyyhw2z6jfwrapd5x41gr29dmcn6ikfixaf9z5";
  };
  libraryHaskellDepends = [
    base bytestring deepseq exceptions template-haskell
  ];
  testHaskellDepends = [
    base bytestring deepseq QuickCheck quickcheck-classes-base
  ];
  benchmarkHaskellDepends = [
    base bytestring deepseq random tasty-bench
  ];
  homepage = "https://github.com/haskell/os-string/blob/master/README.md";
  description = "Library for manipulating Operating system strings";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
