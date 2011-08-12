{ cabal, cereal, cryptoApi, cryptocipher, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.2.1";
  sha256 = "0q6qkvha7cckz3zjnzfsrx298arzbdavy1f73hygrd8f7n74442j";
  buildDepends = [ cereal cryptoApi cryptocipher random ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-cprng-aes";
    description = "Crypto Pseudo Random Number Generator using AES in counter mode";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
