{cabal, gtk2hsBuildtools, pkgconfig, glib, glibc}:

cabal.mkDerivation (self : {
  pname = "glib";
  version = "0.11.2";
  sha256 = "e0fb5f3c22701807db364dff86d55f2a33a57d8a4e58d37a80d367bca50b3dbb";
  extraBuildInputs = [pkgconfig glib glibc gtk2hsBuildtools];
  meta = {
    description = "Binding to the GLIB library for Gtk2Hs";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
