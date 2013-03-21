{ cabal, ansiTerminal, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, setenv, silently
, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.4.5";
  sha256 = "1dfwc1gjsawafi6k19hsw4kd5ahp8a9hdkyrm7nhjp4kjzgd2ymf";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck setenv
    silently time transformers
  ];
  testDepends = [
    ansiTerminal doctest filepath ghcPaths hspecExpectations hspecMeta
    HUnit QuickCheck setenv silently time transformers
  ];
  meta = {
    homepage = "http://hspec.github.com/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
