{
  mkDerivation,
  base,
  criterion,
  deepseq,
  fetchzip,
  ghc-prim,
  lib,
  QuickCheck,
}:
mkDerivation {
  pname = "pretty";
  version = "1.1.3.6";
  src = fetchzip {
    url = "https://hackage.haskell.org/package/pretty-1.1.3.6/pretty-1.1.3.6.tar.gz";
    sha256 = "07jvp2clazn638dbg945i9s7a3zkvr3xrzn619azrlpyy0wjjhp5";
  };
  libraryHaskellDepends = [
    base
    deepseq
    ghc-prim
  ];
  testHaskellDepends = [
    base
    deepseq
    ghc-prim
    QuickCheck
  ];
  benchmarkHaskellDepends = [
    base
    criterion
  ];
  homepage = "http://github.com/haskell/pretty";
  description = "Pretty-printing library";
  license = lib.licenses.bsd3;
}
