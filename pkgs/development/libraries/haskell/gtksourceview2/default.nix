{cabal, gtk2hsBuildtools, pkgconfig, gtksourceview, glib, gtk, gtkC, glibc}:

cabal.mkDerivation (self: {
  pname = "gtksourceview2";
  version = "0.12.2";
  sha256 = "0l9y48kmzqzps6k54fgf0dkmmv0ppxx8amggfdswwk86zsf8j81r";
  extraBuildInputs = [pkgconfig gtksourceview gtkC glibc gtk2hsBuildtools];
  propagatedBuildInputs = [glib gtk];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Binding to the GtkSourceView library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
