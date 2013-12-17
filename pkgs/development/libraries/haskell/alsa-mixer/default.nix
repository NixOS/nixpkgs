{ cabal, alsaLib, alsaCore, extensibleExceptions, c2hs }:

cabal.mkDerivation (self: {
  pname = "alsa-mixer";
  version = "0.1.2";
  sha256 = "081f3a62f83a269d72e0b0fac8bae8c81e9ec342d592fa25abe57f7206cf4414";
  buildDepends = [ extensibleExceptions alsaCore c2hs ];
  pkgconfigDepends = [ alsaLib ];
  meta = {
    homepage = "http://hackage.haskell.org/package/alsa-mixer";
    description = "This package provides bindings to the ALSA simple mixer API.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.linux;
  };
})
