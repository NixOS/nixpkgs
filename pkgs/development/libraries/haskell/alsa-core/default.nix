{ cabal, alsaLib, extensibleExceptions }:

cabal.mkDerivation (self: {
  pname = "alsa-core";
  version = "0.5.0.1";
  sha256 = "1avh4a419h9d2zsslg6j8hm87ppgsgqafz8ll037rk2yy1g4jl7b";
  buildDepends = [ extensibleExceptions ];
  pkgconfigDepends = [ alsaLib ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/ALSA";
    description = "Binding to the ALSA Library API (Exceptions)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.linux;
  };
})
