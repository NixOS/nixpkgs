{ cabal, glib, gtk2hsBuildtools, mtl }:

cabal.mkDerivation (self: {
  pname = "gio";
  version = "0.12.5.3";
  sha256 = "1n9sima0m30w1bmfk0wb4fawrg76vgpvlzki0kwdh6f0sfczxywc";
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
