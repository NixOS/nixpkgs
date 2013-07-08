{ cabal, ansiTerminal, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, random, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.6.1";
  sha256 = "16gwzc5x04kj7847w4nw0msj7myk22hlfkpal9dcpdvslzzy44nh";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal deepseq filepath hspecExpectations HUnit QuickCheck
    quickcheckIo random setenv time transformers
  ];
  testDepends = [
    ansiTerminal deepseq doctest filepath ghcPaths hspecExpectations
    hspecMeta HUnit QuickCheck quickcheckIo random setenv silently time
    transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
