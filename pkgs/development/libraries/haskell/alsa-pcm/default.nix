{ cabal, alsaCore, alsaLib, extensibleExceptions, sampleFrame
, storableRecord
}:

cabal.mkDerivation (self: {
  pname = "alsa-pcm";
  version = "0.6";
  sha256 = "10cmlf1s9y65cs81wn7xwgcd4218n3h3p34avibv3fa7n3q9b4x1";
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
