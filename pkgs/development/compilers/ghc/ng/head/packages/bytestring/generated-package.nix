{
  mkDerivation,
  base,
  deepseq,
  fetchzip,
  ghc-prim,
  lib,
  QuickCheck,
  random,
  syb,
  tasty,
  tasty-bench,
  tasty-quickcheck,
  template-haskell,
  transformers,
}:
mkDerivation {
  pname = "bytestring";
  version = "0.12.2.0";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/bytestring-0.12.2.0/bytestring-0.12.2.0.tar.gz";
    sha256 = "1b8nb46ylwi1nxcnvpncm47dw3x91l3avc7za4c6x9snaz1q84kc";
  };
  libraryHaskellDepends = [
    base
    deepseq
    ghc-prim
    template-haskell
  ];
  testHaskellDepends = [
    base
    deepseq
    QuickCheck
    syb
    tasty
    tasty-quickcheck
    template-haskell
    transformers
  ];
  benchmarkHaskellDepends = [
    base
    deepseq
    random
    tasty-bench
  ];
  homepage = "https://github.com/haskell/bytestring";
  description = "Fast, compact, strict and lazy byte strings with a list interface";
  license = lib.meta.getLicenseFromSpdxId "BSD-3-Clause";
}
