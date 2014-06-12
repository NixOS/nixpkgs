{ cabal, ansiTerminal, async, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, random, setenv, silently, tfRandom, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec2";
  version = "0.3.3";
  sha256 = "0rza34smm30h6jfdb4f4is45j5bp59nq8bn34l1bmv3aiw9kjbmz";
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
  meta = {
    homepage = "http://hspec.github.io/";
    description = "Alpha version of Hspec 2.0";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
