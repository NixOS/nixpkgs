{ cabal, glib, gtk, gtk2hsBuildtools, gtkC, libc, libglade
, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "glade";
  version = "0.12.5.0";
  sha256 = "0dbl7y5rdwzcham16iym9cikfyaphzr1rqcsni9ab6s2368a1vkr";
  buildDepends = [ glib gtk ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ gtkC libglade ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the glade library";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
