{ cabal, byteable, cipherAes, cryptoRandom, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.5.1";
  sha256 = "1bw76y2krcshimvwzph76d69bdfaxfi21w4dxfslmqm78knlls47";
  buildDepends = [ byteable cipherAes cryptoRandom random ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cprng-aes";
    description = "Crypto Pseudo Random Number Generator using AES in counter mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
