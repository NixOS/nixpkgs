{ cabal, hinotify, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.3";
  sha256 = "17m47rfd1pw4dkw1ghlkfm9cjir0cpgrsasx4vsbj07f2nzidx8a";
  buildDepends = [ hinotify systemFileio systemFilepath text time ];
  meta = {
    description = "Cross platform library for file creation, modification, and deletion notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
