{ cabal, cereal, conduit, cryptoApi, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-conduit";
  version = "0.4.0.1";
  sha256 = "1afkn9kp5y1qsgd2l2q85d2bh0wbvn07x0ddi72sr8g7daw8zrs8";
  buildDepends = [ cereal conduit cryptoApi transformers ];
  meta = {
    homepage = "https://github.com/meteficha/crypto-conduit";
    description = "Conduit interface for cryptographic operations (from crypto-api)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
