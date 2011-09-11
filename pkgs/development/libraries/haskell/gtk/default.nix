{ cabal, cairo, glib, gtk, gtk2hsBuildtools, mtl, pango
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtk";
  version = "0.12.0";
  sha256 = "1rqy0390rahdrlb1ba1hjrygwin8ynxzif5flcici22bg5ixsgs2";
  buildDepends = [ cairo glib mtl pango ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ self.stdenv.gcc.libc pkgconfig ];
  pkgconfigDepends = [ glib gtk ];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Binding to the Gtk+ graphical user interface library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
