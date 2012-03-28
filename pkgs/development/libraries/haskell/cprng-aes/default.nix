{ cabal, cereal, cryptoApi, cryptocipher, entropy, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.2.3";
  sha256 = "1xyphzb3afvw7kpgq3b0c86b45rp5a8s870gag1lp7h686lhfnn3";
  buildDepends = [ cereal cryptoApi cryptocipher entropy random ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cprng-aes";
    description = "Crypto Pseudo Random Number Generator using AES in counter mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
