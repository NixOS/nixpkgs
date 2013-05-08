{ cabal, asn1Types }:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey-types";
  version = "0.3.2";
  sha256 = "12gzx4mj8rc243vvjkzvrxnj2f7x3z86yfgahx3my5vsaw4bix2h";
  buildDepends = [ asn1Types ];
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
