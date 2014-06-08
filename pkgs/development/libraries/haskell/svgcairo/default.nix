{ cabal, cairo, glib, gtk2hsBuildtools, libc, librsvg, mtl }:

cabal.mkDerivation (self: {
  pname = "svgcairo";
  version = "0.12.5.2";
  sha256 = "0l3903fzd5pk9wmxjdmx6vyym2r90b33hs6p2sfdks2lx352i94l";
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
