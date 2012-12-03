{ cabal, cipherAes, cryptoApi, cryptoRandomApi, entropy, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.3.0";
  sha256 = "1a8imapda8k0rf0bvag1iin66f2r97pfgip7dkvpvmdkp3j1212h";
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
