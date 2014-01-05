{ cabal, cairo, glib, gtk2hsBuildtools, libc, librsvg, mtl }:

cabal.mkDerivation (self: {
  pname = "svgcairo";
  version = "0.12.5.0";
  sha256 = "1b5n96l8addif8a6yv21w95g83dpamr043yqm2wb7vaca8m82r28";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc ];
  pkgconfigDepends = [ librsvg ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the libsvg-cairo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
