{ cabal, ansiTerminal, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, random, setenv, silently, tfRandom, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.9.2";
  sha256 = "0q8a1n03d70l86l2yy98j180xbnfq0ijgcf5llv439b65lc4zcyf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal deepseq filepath hspecExpectations HUnit QuickCheck
    quickcheckIo random setenv tfRandom time transformers
  ];
  testDepends = [
    ansiTerminal deepseq doctest filepath ghcPaths hspecExpectations
    hspecMeta HUnit QuickCheck quickcheckIo random setenv silently
    tfRandom time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
