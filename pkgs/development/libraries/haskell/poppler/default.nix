{ cabal, cairo, gdk_pixbuf, glib, gtk, gtk2hsBuildtools, libc, mtl
, pango, popplerGlib
}:

cabal.mkDerivation (self: {
  pname = "poppler";
  version = "0.12.2.2";
  sha256 = "1ln5akiarv1ng5gjrzf8bnkm556xzl50m209qvi5nk98g7fyhqs7";
  buildDepends = [ cairo glib gtk mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc ];
  pkgconfigDepends = [ cairo gdk_pixbuf glib gtk pango popplerGlib ];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Binding to the Poppler";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ianwookim ];
  };
})
