{ cabal, ansiTerminal, async, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, random, setenv, silently, tfRandom, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.10.0";
  sha256 = "0lqc4sxl2c1rgnmp4a2fikc78f9caxswkmxfi8wajxlwaj58sy8p";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal async deepseq filepath hspecExpectations HUnit
    QuickCheck quickcheckIo random setenv tfRandom time transformers
  ];
  testDepends = [
    ansiTerminal async deepseq doctest filepath ghcPaths
    hspecExpectations hspecMeta HUnit QuickCheck quickcheckIo random
    setenv silently tfRandom time transformers
  ];
  doCheck = false;
  meta = {
    homepage = "http://hspec.github.io/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
