{ cabal, cryptoApi }:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey-types";
  version = "0.1.0";
  sha256 = "1ib5bqxydvv37l53wl6b4j6m6y904rsiamhh144lm6rmqiym26f5";
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
