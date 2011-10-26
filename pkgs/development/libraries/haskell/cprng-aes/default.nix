{ cabal, cereal, cryptoApi, cryptocipher, entropy, random }:

cabal.mkDerivation (self: {
  pname = "cprng-aes";
  version = "0.2.2";
  sha256 = "0jfa9fb670bqlnkplmscz878hvdbpap47xfxvshgs102iq7rjasf";
  buildDepends = [ cereal cryptoApi cryptocipher entropy random ];
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
