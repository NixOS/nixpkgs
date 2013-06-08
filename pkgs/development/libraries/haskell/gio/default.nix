{ cabal, glib, gtk2hsBuildtools, mtl }:

cabal.mkDerivation (self: {
  pname = "gio";
  version = "0.12.4";
  sha256 = "0npvq77z72c9z009krvs4n9vv3gqj6g8fdqd777kzw1dbkhp9ziy";
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
