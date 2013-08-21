{ cabal, ansiTerminal, deepseq, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, random, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.7.0";
  sha256 = "0cw24vmns06z5308wva9bb5czs9i5wm6qdhymgiyl2i47ibxp5bj";
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
