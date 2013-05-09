{ cabal, ansiTerminal, deepseq, filepath, hspecExpectations, HUnit
, QuickCheck, quickcheckIo, random, setenv, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.5.4";
  sha256 = "07m7wxannk9rr8q2bdxhkjjlvwlzp7lq2c41y6cgjkjcm2x9qcc8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal deepseq filepath hspecExpectations HUnit QuickCheck
    quickcheckIo random setenv time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.com/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
