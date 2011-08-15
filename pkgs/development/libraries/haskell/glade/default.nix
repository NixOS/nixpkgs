{cabal, cairo, glib, gtk, mtl, pango, gtk2hsBuildtools, pkgconfig, gnome, glibc}:

cabal.mkDerivation (self: {
  pname = "glade";
  version = "0.12.0";
  sha256 = "0h7l1kp9y17xqyz16kv0dvwgblph9r70wimyl8aq9gi1r4is5lmq";
  extraBuildInputs = [pkgconfig gtk2hsBuildtools gnome.libglade gnome.gtk glibc];
  propagatedBuildInputs = [cairo glib gtk mtl pango];
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
