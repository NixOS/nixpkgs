{ cabal, glib, gtk, gtk2hsBuildtools, gtksourceview, libc, mtl
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtksourceview2";
  version = "0.12.3";
  sha256 = "0bhwvhwsg3mf4w94fl6z6qkn67i68hh3zwwhzqa59lia0nc233gd";
  buildDepends = [ glib gtk mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ gtksourceview ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the GtkSourceView library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
