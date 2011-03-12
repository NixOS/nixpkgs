{cabal, gtk2hsBuildtools, pkgconfig, glib, glibc}:

cabal.mkDerivation (self : {
  pname = "glib";
  version = "0.12.0";
  sha256 = "1sqkj6adg87ccdnl9yy1p8yrv5xnfcrlaflj52nrh6anwlqy9z19";
  extraBuildInputs = [pkgconfig glib glibc gtk2hsBuildtools];
  meta = {
    description = "Binding to the GLIB library for Gtk2Hs";
    license = "LGPLv2+";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
