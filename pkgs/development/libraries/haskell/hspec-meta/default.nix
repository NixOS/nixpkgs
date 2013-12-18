{ cabal, ansiTerminal, deepseq, filepath, hspecExpectations, HUnit
, QuickCheck, quickcheckIo, random, setenv, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.8.1";
  sha256 = "03582b79cqv3c2z02ni2xyzb3kccgcw0phmg5lklaphkrarm0g3w";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal deepseq filepath hspecExpectations HUnit QuickCheck
    quickcheckIo random setenv time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
