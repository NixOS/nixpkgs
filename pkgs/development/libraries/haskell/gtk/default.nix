{ cabal, cairo, glib, gtk, gtk2hsBuildtools, libc, mtl, pango
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtk";
  version = "0.12.5.7";
  sha256 = "0hax4ixdz523753rc774c8g76bjlj56lsabyl5nwkpnppffpa73w";
  buildDepends = [ cairo glib mtl pango ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ glib gtk ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Gtk+ graphical user interface library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
