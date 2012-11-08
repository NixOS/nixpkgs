{ cabal, hinotify, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.2";
  sha256 = "14pvyky3wg1k1lrv41rymi4mihvdpkx8vfv43wa0z6g4a6456ayz";
  buildDepends = [ hinotify systemFileio systemFilepath text time ];
  meta = {
    description = "Cross platform library for file creation, modification, and deletion notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
