{ cabal, aeson, binary, blazeBuilder, Cabal, caseInsensitive
, cmdargs, conduit, deepseq, filepath, haskellSrcExts, httpTypes
, parsec, QuickCheck, random, safe, shake, tagsoup, text, time
, transformers, uniplate, vector, vectorAlgorithms, wai, warp
}:

cabal.mkDerivation (self: {
  pname = "hoogle";
  version = "4.2.30";
  sha256 = "0vw0chqsq8wmi1mpdxj1c9g4ah7lqxm8rwh85j2vyp56vfscw9q1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    aeson binary blazeBuilder Cabal caseInsensitive cmdargs conduit
    deepseq filepath haskellSrcExts httpTypes parsec QuickCheck random
    safe shake tagsoup text time transformers uniplate vector
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
