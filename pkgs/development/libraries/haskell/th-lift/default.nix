{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "th-lift";
  version = "0.5.5";
  sha256 = "1zp9alv3nbvra1rscddak3i33c2jnv6g6806h94qbfkq3zbimfi0";
  buildDepends = [ Cabal ];
  meta = {
    description = "Derive Template Haskell's Lift class for datatypes";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
