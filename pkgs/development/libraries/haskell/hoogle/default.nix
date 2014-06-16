{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, QuickCheck, random, resourcet, safe, shake, tagsoup, text
, time, transformers, uniplate, vector, vectorAlgorithms, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.33";
  sha256 = "0jwik79qcflaghqxfvsd8xvb7y1czb1xihg1ijd29lx7p5mz03il";
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
