{ cabal, cairo, glib, glibc, gtk2hsBuildtools, librsvg, mtl }:

cabal.mkDerivation (self: {
  pname = "svgcairo";
  version = "0.12.0";
  sha256 = "1zialw59njmq0sfz9f0rx6v50d4bvld2ivmwljkp5bmxii3hcjl3";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ glibc ];
  pkgconfigDepends = [ cairo librsvg ];
  meta = {
    homepage = "http://www.haskell.org/gtk2hs/";
    description = "Binding to the libsvg-cairo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
