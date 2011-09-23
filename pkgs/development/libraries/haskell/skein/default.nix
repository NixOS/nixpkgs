{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "0.1";
  sha256 = "10fnhbjdq4vrpl17b27pmxg943wsxv27js6p5nrgyzx9ybmdrmdi";
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    description = "Skein, a family of cryptographic hash functions. Includes Skein-MAC as well.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
