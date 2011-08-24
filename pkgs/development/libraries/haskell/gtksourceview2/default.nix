{ cabal, glib, glibc, gtk, gtk2hsBuildtools, gtksourceview, mtl
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtksourceview2";
  version = "0.12.2";
  sha256 = "0l9y48kmzqzps6k54fgf0dkmmv0ppxx8amggfdswwk86zsf8j81r";
  buildDepends = [ glib gtk mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ glibc pkgconfig ];
  pkgconfigDepends = [ gtksourceview ];
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
