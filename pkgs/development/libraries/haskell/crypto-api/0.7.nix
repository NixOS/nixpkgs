{ cabal, cereal, entropy, largeword, tagged }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.7";
  sha256 = "0831rmkq603ga9py5xxfw77qixdliyh15dxh9ls7rd7ia6sqjvx0";
  buildDepends = [ cereal entropy largeword tagged ];
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
