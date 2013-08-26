{ cabal, cereal, entropy, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.12.2.2";
  sha256 = "0qmv8vizrbjs3k2f78r6ykyilps4zp7xxpzdxw7rngh154wqgv1k";
  buildDepends = [ cereal entropy tagged transformers ];
  meta = {
    homepage = "https://github.com/TomMD/crypto-api";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
