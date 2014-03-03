{ cabal, cairo, glib, gtk2hsBuildtools, libc, mtl, pango, pkgconfig
}:

cabal.mkDerivation (self: {
  pname = "pango";
  version = "0.12.5.3";
  sha256 = "1n64ppz0jqrbzvimbz4avwnx3z0n5z2gbmbmca0hw9wqf9j6y79a";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc pkgconfig ];
  pkgconfigDepends = [ cairo pango ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Pango text rendering engine";
    license = self.stdenv.lib.licenses.lgpl21;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
