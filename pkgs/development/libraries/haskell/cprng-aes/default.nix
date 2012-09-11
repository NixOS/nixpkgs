{ cabal, cereal, cipherAes, cryptoApi, cryptocipher, entropy
, random
}:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.2.4";
  sha256 = "0rk14yj76p5a1h6jlz4q2fgijjid430lwcr57zkkda8mdibqqs5j";
  buildDepends = [
    cereal cipherAes cryptoApi cryptocipher entropy random
  ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cprng-aes";
    description = "Crypto Pseudo Random Number Generator using AES in counter mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
