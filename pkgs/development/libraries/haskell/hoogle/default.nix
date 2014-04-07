{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, QuickCheck, random, resourcet, safe, shake, tagsoup, text
, time, transformers, uniplate, vector, vectorAlgorithms, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.31";
  sha256 = "176lyj236ncq0lg7vbl4bbm1a98ficj82aranrhyxdjzmbk3i67x";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec QuickCheck random
    resourcet safe shake tagsoup text time transformers uniplate vector
    vectorAlgorithms wai warp
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
