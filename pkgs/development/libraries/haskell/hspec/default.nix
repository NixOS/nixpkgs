{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, setenv, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.4.2.2";
  sha256 = "0dsavcawa54pjicibb48648iy6bzggkvhiklksq85xq4ywg7r3g5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck setenv
    silently time transformers
  ];
  meta = {
    homepage = "http://hspec.github.com/";
    description = "Behavior-Driven Development for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
