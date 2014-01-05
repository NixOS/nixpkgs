{ cabal, glib, gtk2hsBuildtools, mtl }:

cabal.mkDerivation (self: {
  pname = "gio";
  version = "0.12.5.0";
  sha256 = "08gg3dh3xsgvj3hwylg5pgrhdrvi1chsybkd0l4hd4bycpm3sx98";
  buildDepends = [ glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  pkgconfigDepends = [ glib ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the GIO";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
