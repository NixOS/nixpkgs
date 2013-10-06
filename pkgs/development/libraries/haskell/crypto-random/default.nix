{ cabal, securemem, vector }:

cabal.mkDerivation (self: {
  pname = "crypto-random";
  version = "0.0.7";
  sha256 = "1dj63y85l3f1x7fw8j7hykz56ajd38iikl3f8ygaz8r95pd1zjxw";
  buildDepends = [ securemem vector ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-random";
    description = "Simple cryptographic random related types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
