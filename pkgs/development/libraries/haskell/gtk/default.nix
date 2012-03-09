{ cabal, cairo, glib, gtk, gtk2hsBuildtools, libc, mtl, pango
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtk";
  version = "0.12.3";
  sha256 = "0a5bb1qkxpkmm69b31jpqy7njnsk9bhhhp6z0h971zsxsrxpi04q";
  buildDepends = [ cairo glib mtl pango ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ glib gtk ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Gtk+ graphical user interface library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
