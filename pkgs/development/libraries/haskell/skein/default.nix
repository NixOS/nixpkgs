{ cabal, cereal, cryptoApi, tagged }:

cabal.mkDerivation (self: {
  pname = "skein";
  version = "0.1.0.6";
  sha256 = "041qg0vy5h5xd0142chbmkhmqxbglrb7x0ybcalrxr7dawxksm8d";
  buildDepends = [ cereal cryptoApi tagged ];
  meta = {
    description = "Skein, a family of cryptographic hash functions. Includes Skein-MAC as well.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
