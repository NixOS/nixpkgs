{ cabal, cipherAes, cryptoApi, cryptoRandomApi, entropy, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.3.2";
  sha256 = "1xwwhg83llf9fzfafxsky65biwk0sla9273rp4gqr7vg9p02k221";
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
