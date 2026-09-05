{
  mkDerivation,
  base,
  bytestring,
  deepseq,
  fetchzip,
  lib,
  mtl,
  tasty,
  tasty-hunit,
  text,
}:
mkDerivation {
  pname = "parsec";
  version = "3.1.18.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/parsec-3.1.18.0/parsec-3.1.18.0.tar.gz";
    sha256 = "089j939xxi6w6a2ggr40c4s2kdbwkzap2mnhvimmf45hg865h48n";
  };
  libraryHaskellDepends = [
    base
    bytestring
    mtl
    text
  ];
  testHaskellDepends = [
    base
    deepseq
    mtl
    tasty
    tasty-hunit
  ];
  homepage = "https://github.com/haskell/parsec";
  description = "Monadic parser combinators";
  license = lib.licenses.bsd2;
}
