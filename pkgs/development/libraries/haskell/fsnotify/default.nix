{ stdenv, cabal, Cabal, Glob, hspec, QuickCheck, random
, systemFileio, systemFilepath, text, time, uniqueid
, hinotify, hfsevents
}:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.11";
  sha256 = "03m911pncyzgfdx4aj38azbbmj25fdm3s9l1w27zv0l730fy8ywq";
  buildDepends = [ systemFileio systemFilepath text time ] ++
    (if stdenv.isDarwin then [ hfsevents ] else [ hinotify ]);
  testDepends = [
    Cabal Glob hspec QuickCheck random systemFileio
    systemFilepath text time uniqueid
  ] ++ (if stdenv.isDarwin then [ hfsevents ] else [ hinotify ]);
  doCheck = false;
  meta = {
    description = "Cross platform library for file change notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
