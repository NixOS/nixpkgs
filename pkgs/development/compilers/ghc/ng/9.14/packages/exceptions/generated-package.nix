{
  mkDerivation,
  base,
  fetchzip,
  lib,
  mtl,
  QuickCheck,
  stm,
  tasty,
  tasty-hunit,
  tasty-quickcheck,
  template-haskell,
  transformers,
}:
mkDerivation {
  pname = "exceptions";
  version = "0.10.11";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/exceptions-0.10.11/exceptions-0.10.11.tar.gz";
    sha256 = "1v7xi9k8752w0drv5m8nyaal31513qmw00scwxx9b3259zm6vsbc";
  };
  libraryHaskellDepends = [
    base
    mtl
    stm
    template-haskell
    transformers
  ];
  testHaskellDepends = [
    base
    mtl
    QuickCheck
    stm
    tasty
    tasty-hunit
    tasty-quickcheck
    template-haskell
    transformers
  ];
  homepage = "http://github.com/ekmett/exceptions/";
  description = "Extensible optionally-pure exceptions";
  license = lib.licenses.bsd3;
}
