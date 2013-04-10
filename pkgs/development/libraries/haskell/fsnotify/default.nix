{ cabal, Cabal, Glob, hinotify, hspec, QuickCheck, random
, systemFileio, systemFilepath, text, time, uniqueid
}:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.7.1";
  sha256 = "1hrnhp22s8pcj525m2vi9b7k3pp5qrv44qhqh6c8n0bgilqwg4yd";
  buildDepends = [ hinotify systemFileio systemFilepath text time ];
  testDepends = [
    Cabal Glob hinotify hspec QuickCheck random systemFileio
    systemFilepath text time uniqueid
  ];
  doCheck = false;
  meta = {
    description = "Cross platform library for file creation, modification, and deletion notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
