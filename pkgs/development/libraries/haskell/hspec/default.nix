{ cabal, ansiTerminal, filepath, hspecExpectations, HUnit
, QuickCheck, silently, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "hspec";
  version = "1.3.0";
  sha256 = "0kl9mdksy8bifb37dfb9y8mnnjlq0x1h970cgzv9idq61gafii4n";
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
