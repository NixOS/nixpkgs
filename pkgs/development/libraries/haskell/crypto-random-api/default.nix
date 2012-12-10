{ cabal, entropy }:

cabal.mkDerivation (self: {
  pname = "crypto-random-api";
  version = "0.1.0";
  sha256 = "1zx05hskzdxm0kfj6x9qsx8f659zv77pa189s3xg56i7h18d25md";
  buildDepends = [ entropy ];
  meta = {
    homepage = "http://github.com/vincenthz/hs-crypto-random-api";
    description = "Simple random generators API for cryptography related code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
