{ cabal }:

cabal.mkDerivation (self: {
  pname = "numtype";
  version = "1.0.1";
  sha256 = "130qchi9dplpg7pxf4pz7nz4mnprngw16mizqycp5pdlawbcp5js";
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Type-level (low cardinality) integers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
