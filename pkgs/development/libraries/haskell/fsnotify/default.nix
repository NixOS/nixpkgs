{ cabal, Cabal, Glob, hinotify, hspec, QuickCheck, random
, systemFileio, systemFilepath, text, time, uniqueid
}:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.8";
  sha256 = "05vfiddp5m28rm02ci7fcfg1zgw5ydj084173mpp1w124bfqf940";
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
