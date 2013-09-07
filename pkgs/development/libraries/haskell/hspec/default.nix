{ cabal, ansiTerminal, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, random, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.7.1";
  sha256 = "0fc8phc36876f8qydc5iwz3i7nri0n6b4dlxv0w4rcxgv9hp7ls0";
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
