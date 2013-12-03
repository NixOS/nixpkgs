{ cabal, glib, gtk, gtk2hsBuildtools, gtksourceview, libc, mtl
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtksourceview2";
  version = "0.12.5.0";
  sha256 = "125psfr58na60nz5ax3va08fq1aa4knzjccj8ghwk8x9fkzddfs9";
  buildDepends = [ glib gtk mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ gtksourceview ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the GtkSourceView library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
