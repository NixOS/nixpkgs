{ cabal, asn1Types }:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey-types";
  version = "0.4.2.1";
  sha256 = "01jxvx4bjk4qj024ydwskp942gsgy15i9jfh3diq9la8yqnidwj2";
  buildDepends = [ asn1Types ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey-types";
    description = "Generic cryptography Public keys algorithm types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
