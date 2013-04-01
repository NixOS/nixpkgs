{ cabal, ansiTerminal, doctest, filepath, ghcPaths
, hspecExpectations, hspecMeta, HUnit, QuickCheck, quickcheckIo
, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.5.1";
  sha256 = "0iz34hgwir07g2qv3zdkg5k5wrv68qd0c77xkpfcs653fi28i91a";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck
    quickcheckIo setenv time transformers
  ];
  testDepends = [
    ansiTerminal doctest filepath ghcPaths hspecExpectations hspecMeta
    HUnit QuickCheck quickcheckIo setenv silently time transformers
  ];
  meta = {
    homepage = "http://hspec.github.com/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
