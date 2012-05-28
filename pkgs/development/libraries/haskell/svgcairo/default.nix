{ cabal, cairo, glib, gtk2hsBuildtools, libc, librsvg, mtl }:

cabal.mkDerivation (self: {
  pname = "svgcairo";
  version = "0.12.1.1";
  sha256 = "0fl9flsv4brvwryzxv4xpy8x3w0if4psx8nypxm2ix6l9qh3pghb";
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
