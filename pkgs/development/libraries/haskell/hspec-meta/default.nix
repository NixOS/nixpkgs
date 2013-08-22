{ cabal, ansiTerminal, deepseq, filepath, hspecExpectations, HUnit
, QuickCheck, quickcheckIo, random, setenv, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.7.0";
  sha256 = "0a1s7pkymn41kk8gp5i7v141vq5yx857rma1l2xffs9lh4qalnq8";
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
