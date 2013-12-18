{ cabal }:

cabal.mkDerivation (self: {
  pname = "th-lift";
  version = "0.6";
  sha256 = "0nsxrmilp2g0nx4s9iigj2llza6phphcfr4j9gvmqmx6kf2z9vns";
  meta = {
    description = "Derive Template Haskell's Lift class for datatypes";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
