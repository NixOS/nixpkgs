{ cabal, cereal, entropy, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.12.2.1";
  sha256 = "03hbjjrwnpa4ji2ig458s0c4g13r566sl6fs3hciwyf6cfq597wk";
  buildDepends = [ cereal entropy tagged transformers ];
  meta = {
    homepage = "https://github.com/TomMD/crypto-api";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
