{ cabal, cereal, cryptoApi, cryptohash, tagged }:

cabal.mkDerivation (self: {
  pname = "cryptohash-cryptoapi";
  version = "0.1.0";
  sha256 = "06b62ddwx2mp71dzaj8h88vw2c6nv3rj8n6d3d9vmqa7cws3mjkx";
  buildDepends = [ cereal cryptoApi cryptohash tagged ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cryptohash-cryptoapi";
    description = "Crypto-api interfaces for cryptohash";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
