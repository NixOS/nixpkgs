{ cabal, cairo, gtk2hsBuildtools, libc, mtl, pkgconfig, utf8String
, zlib
}:

cabal.mkDerivation (self: {
  pname = "cairo";
  version = "0.12.5.3";
  sha256 = "1g5wn7dzz8cc7my09igr284j96d795jlnmy1q2hhlvssfhwbbvg7";
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
