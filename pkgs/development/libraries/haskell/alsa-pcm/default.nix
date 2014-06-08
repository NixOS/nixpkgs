{ cabal, alsaCore, alsaLib, extensibleExceptions, sampleFrame
, storableRecord
}:

cabal.mkDerivation (self: {
  pname = "alsa-pcm";
  version = "0.6.0.2";
  sha256 = "0zckp83wdqb6nl2k63fapa5h4vf1xyvbaycd0ixwr9k7mw75q7b9";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    alsaCore extensibleExceptions sampleFrame storableRecord
  ];
  pkgconfigDepends = [ alsaLib ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/ALSA";
    description = "Binding to the ALSA Library API (PCM audio)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.linux;
  };
})
