{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, random, safe, shake, tagsoup, text, time, transformers
, uniplate, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.27";
  sha256 = "0a92bcvgkk58yrsvkfrdk64qc0hhxgkyjpv39nmy8vf10ihg7wqn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec random safe shake
    tagsoup text time transformers uniplate wai warp
  ];
  testDepends = [ filepath ];
  testTarget = "--test-option=--no-net";
  meta = {
    homepage = "http://www.haskell.org/hoogle/";
    description = "Haskell API Search";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
