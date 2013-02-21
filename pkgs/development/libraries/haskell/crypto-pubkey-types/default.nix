{ cabal }:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey-types";
  version = "0.2.0";
  sha256 = "1arzkyxcm1ffnwk7imxkwvyi20dp8n960vzj7cbl7fhv3j04c9xq";
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey-types";
    description = "Generic cryptography Public keys algorithm types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
