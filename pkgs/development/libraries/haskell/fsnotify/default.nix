{ cabal, hinotify, systemFileio, systemFilepath, text, time }:

cabal.mkDerivation (self: {
  pname = "fsnotify";
  version = "0.0.4";
  sha256 = "0s71zxj48jimzhl7wz9j22g9c09z64g61nfmpy4mlrhpkzn1f8sz";
  buildDepends = [ hinotify systemFileio systemFilepath text time ];
  meta = {
    description = "Cross platform library for file creation, modification, and deletion notification";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
