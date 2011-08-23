{ cabal, glib, glibc, gtk2hsBuildtools, pkgconfig }:

cabal.mkDerivation (self: {
  pname = "glib";
  version = "0.12.0";
  sha256 = "1sqkj6adg87ccdnl9yy1p8yrv5xnfcrlaflj52nrh6anwlqy9z19";
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ glibc pkgconfig ];
  pkgconfigDepends = [ glib ];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Binding to the GLIB library for Gtk2Hs";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
