{ cabal, cryptoApi }:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey-types";
  version = "0.1.1";
  sha256 = "0chlz01nlxnh9bk5b97vm6q6ai0ifybkdaynwibj8px418mmbkib";
  buildDepends = [ cryptoApi ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey-types";
    description = "Generic cryptography Public keys algorithm types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
