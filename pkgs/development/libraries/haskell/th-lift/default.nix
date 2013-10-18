{ cabal }:

cabal.mkDerivation (self: {
  pname = "th-lift";
  version = "0.5.6";
  sha256 = "128rbpqbm4fgn1glbv8bvlqnvn2wvca7wj08xri25w3bikmfy2z4";
  meta = {
    description = "Derive Template Haskell's Lift class for datatypes";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
