{ cabal, Cabal, cereal, entropy, largeword, tagged }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.9";
  sha256 = "11372brnpiqdm6fdfp95wyyl8nvhbagnq0q2bdhn4xsskpnp4hnp";
  buildDepends = [ Cabal cereal entropy largeword tagged ];
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
