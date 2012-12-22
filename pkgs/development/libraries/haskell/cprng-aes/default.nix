{ cabal, cipherAes, cryptoApi, cryptoRandomApi, entropy, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.3.1";
  sha256 = "0z1kpgy9d4yp1vmcparsv3r5g1khv2yqqkr99ac3mgvr6pyh24dk";
  buildDepends = [
    cipherAes cryptoApi cryptoRandomApi entropy random
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cprng-aes";
    description = "Crypto Pseudo Random Number Generator using AES in counter mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
