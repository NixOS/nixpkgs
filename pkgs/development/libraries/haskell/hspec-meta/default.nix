{ cabal, ansiTerminal, deepseq, filepath, hspecExpectations, HUnit
, QuickCheck, quickcheckIo, random, setenv, tfRandom, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec-meta";
  version = "1.9.3";
  sha256 = "11x2yh4nqcg77pyszygfla0i20l3f1cxvix4va6rqzcbksc51lvd";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal deepseq filepath hspecExpectations HUnit QuickCheck
    quickcheckIo random setenv tfRandom time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "A version of Hspec which is used to test Hspec itself";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
