{ cabal, cairo, glib, glibc, gtk, gtk2hsBuildtools, gtkC, libglade
, mtl, pango, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "glade";
  version = "0.12.0";
  sha256 = "0h7l1kp9y17xqyz16kv0dvwgblph9r70wimyl8aq9gi1r4is5lmq";
  buildDepends = [ cairo glib gtk mtl pango ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ glibc pkgconfig ];
  pkgconfigDepends = [ gtkC libglade ];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Binding to the glade library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
