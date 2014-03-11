{ cabal, cereal, cryptoApi, cryptohash, tagged }:

cabal.mkDerivation (self: {
  pname = "cryptohash-cryptoapi";
  version = "0.1.2";
  sha256 = "1i2qxyq5qk4jzgkl7kndy10sbmzmagamfnqvl300qm3msi9k0kfy";
  buildDepends = [ cereal cryptoApi cryptohash tagged ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash-cryptoapi";
    description = "Crypto-api interfaces for cryptohash";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
