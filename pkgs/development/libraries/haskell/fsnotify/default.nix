{ cabal, Cabal, Glob, hinotify, hspec, QuickCheck, random
, systemFileio, systemFilepath, text, time, uniqueid
}:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.11";
  sha256 = "03m911pncyzgfdx4aj38azbbmj25fdm3s9l1w27zv0l730fy8ywq";
  buildDepends = [ hinotify systemFileio systemFilepath text time ];
  testDepends = [
    Cabal Glob hinotify hspec QuickCheck random systemFileio
    systemFilepath text time uniqueid
  ];
  doCheck = false;
  meta = {
    description = "Cross platform library for file change notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
