{ cabal, asn1Types }:

cabal.mkDerivation (self: {
  pname = "crypto-pubkey-types";
  version = "0.4.2.2";
  sha256 = "18z1fnh2xjq600ya8m175m64nwr6bwscr2q47zjy7k38zlm9c8h5";
  buildDepends = [ asn1Types ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-pubkey-types";
    description = "Generic cryptography Public keys algorithm types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
