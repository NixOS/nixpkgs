{ cabal, cereal, entropy, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.12";
  sha256 = "09ra5bz2s5n2zq57n6ylsj7a482bsxpxhybmp04g796h87xgy7xs";
  buildDepends = [ cereal entropy tagged transformers ];
  jailbreak = true;
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
