{ cabal, Cabal, Glob, hinotify, hspec, QuickCheck, random
, systemFileio, systemFilepath, text, time, uniqueid
}:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.7";
  sha256 = "0yx69kdy67pjkwfrd5r00lhprbf98j9za31f7vaxxf2lbgqlmk9q";
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
