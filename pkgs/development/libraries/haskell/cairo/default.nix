{ cabal, cairo, gtk2hsBuildtools, libc, mtl, pkgconfig, zlib }:

cabal.mkDerivation (self: {
  pname = "cairo";
  version = "0.12.1";
  sha256 = "0krclr32cn3vq3cmwhmxz7wzams92iliq44p6s4nj9jg4928cgfk";
  buildDepends = [ mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ cairo libc pkgconfig zlib ];
  pkgconfigDepends = [ cairo ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Cairo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
