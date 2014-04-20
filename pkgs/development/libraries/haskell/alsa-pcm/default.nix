{ cabal, alsaCore, alsaLib, extensibleExceptions, sampleFrame
, storableRecord
}:

cabal.mkDerivation (self: {
  pname = "alsa-pcm";
  version = "0.6.0.1";
  sha256 = "0gnq4p172sqmlks6aykzr5l2qx2shrs2fypcvs4g56c9zpk3c3ax";
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
