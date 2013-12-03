{ cabal, cairo, glib, gtk, gtk2hsBuildtools, libc, mtl, pango
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtk";
  version = "0.12.5.0";
  sha256 = "1xj2x9aakk70k3z88klfniqvffzbdkn55vslbqk60k6sv4k3qs2n";
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
