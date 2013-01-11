{ cabal, hinotify, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.6";
  sha256 = "0ib6ansj3vaq9hxxbsq5jw14w2b61wp4jfahzb3c3x46mdb1bqw5";
  buildDepends = [ hinotify systemFileio systemFilepath text time ];
  meta = {
    description = "Cross platform library for file creation, modification, and deletion notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
