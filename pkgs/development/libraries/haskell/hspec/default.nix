{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.3.0.1";
  sha256 = "1xgj1yg49vb524blswclr0yw4pvfpbmjyh0b62fac14mawl89v36";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    ansiTerminal filepath hspecExpectations HUnit QuickCheck silently
    time transformers
  ];
  meta = {
    homepage = "http://hspec.github.com/";
    description = "Behavior Driven Development for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
