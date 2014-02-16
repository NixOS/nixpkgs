{ cabal, cairo, gtk2hsBuildtools, libc, mtl, pkgconfig, utf8String
, zlib
}:

cabal.mkDerivation (self: {
  pname = "cairo";
  version = "0.12.5.1";
  sha256 = "02a57kg7s1bjfvk7cnkppfva5g7akhpwsrsa1qzm0kdld51cs86l";
  buildDepends = [ mtl utf8String ];
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
