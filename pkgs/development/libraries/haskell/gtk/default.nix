{ cabal, cairo, glib, gtk, gtk2hsBuildtools, libc, mtl, pango
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtk";
  version = "0.12.3.1";
  sha256 = "0v9sh07lpvih2gk4ivy0jx2slw7rpvbf75xp20plzgzmay1y978s";
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
