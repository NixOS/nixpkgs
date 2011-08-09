{ cabal }:

cabal.mkDerivation (self: {
  pname = "th-lift";
  version = "0.5.3";
  sha256 = "15jynhl1ly0zhk2g9rm8vxas9p76w1lfxqhjw5rfb8s5k1w73fil";
  meta = {
    description = "Derive Template Haskell's Lift class for datatypes.";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
