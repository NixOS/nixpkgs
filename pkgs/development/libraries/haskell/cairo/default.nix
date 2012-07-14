{ cabal, cairo, gtk2hsBuildtools, libc, mtl, pkgconfig, zlib }:

cabal.mkDerivation (self: {
  pname = "cairo";
  version = "0.12.3.1";
  sha256 = "173pql0n51a9z46vzpwd9q67nblhb61qirynjra9vzydiy79bfwi";
  buildDepends = [ mtl ];
  buildTools = [ gtk2hsBuildtools ];
  extraLibraries = [ cairo libc pkgconfig zlib ];
  pkgconfigDepends = [ cairo ];
  meta = {
    homepage = "http://projects.haskell.org/gtk2hs/";
    description = "Binding to the Cairo library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
