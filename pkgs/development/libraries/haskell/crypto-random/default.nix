{ cabal, securemem, vector }:

cabal.mkDerivation (self: {
  pname = "crypto-random";
  version = "0.0.5";
  sha256 = "1wvbbqqfqaylq9w8pyiz243d06ivh982mhb2ci5yhjl06vqv2gk3";
  buildDepends = [ securemem vector ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-random";
    description = "Simple cryptographic random related types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
