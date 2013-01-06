{ cabal, hinotify, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.5";
  sha256 = "1pi1dpm48igcc8n5cn8hdml8bknxl18kqhjbh6jan839fgmwagb9";
  buildDepends = [ hinotify systemFileio systemFilepath text time ];
  meta = {
    description = "Cross platform library for file creation, modification, and deletion notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
