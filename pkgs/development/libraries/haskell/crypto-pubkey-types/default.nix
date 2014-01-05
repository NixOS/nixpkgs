{ cabal, asn1Types }:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey-types";
  version = "0.4.1";
  sha256 = "1zs0hhpqcfsdyfr3z96m8lwxrxr3mf27wvjrpvih9jlvh64vp1pr";
  buildDepends = [ asn1Types ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey-types";
    description = "Generic cryptography Public keys algorithm types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
