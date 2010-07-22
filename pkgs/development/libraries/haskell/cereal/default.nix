{cabal}:

cabal.mkDerivation (self : {
  pname = "cereal";
  version = "0.2";
  sha256 = "aa00eb88cea5616a0eb9e4b6604cb164b8bef6e86b111cbb67d51d4d3441332b";
  meta = {
    description = "A binary serialization library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
