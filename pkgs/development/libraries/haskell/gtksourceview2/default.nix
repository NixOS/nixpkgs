{ cabal, glib, gtk, gtk2hsBuildtools, gtksourceview, libc, mtl
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "gtksourceview2";
  version = "0.12.3.1";
  sha256 = "1c91ja753dzr2c7sv13wn47sjbjg45jv8xx9ybx1q3188xrldqng";
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
