{ cabal, cairo, glib, gtk2hsBuildtools, libc, librsvg, mtl }:

cabal.mkDerivation (self: {
  pname = "svgcairo";
  version = "0.12.1";
  sha256 = "1nyr849ayk1fyjpxnpam1pychny609d6j2v3is84llh3gsyq99ps";
  buildDepends = [ cairo glib mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ libc ];
  pkgconfigDepends = [ librsvg ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the libsvg-cairo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
