{ cabal, cipherAes, cryptoApi, cryptoRandomApi, entropy, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.3.4";
  sha256 = "0k1zh4nw30qgdrkgn6x6zfbpp129f9cparzyqsdqfbf44j0mf2rw";
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
