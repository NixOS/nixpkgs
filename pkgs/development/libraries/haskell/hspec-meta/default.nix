{ cabal, ansiTerminal, deepseq, filepath, hspecExpectations, HUnit
, QuickCheck, quickcheckIo, random, setenv, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.7.2";
  sha256 = "03ksxx7w61iw3hf055mjb47bjh8srwxpqxs5bxqdqrilfd1cixmj";
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
