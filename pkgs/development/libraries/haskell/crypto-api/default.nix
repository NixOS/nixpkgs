{ cabal, cereal, entropy, largeword, tagged }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.10.1";
  sha256 = "1l73c9pik6109frzyrxh8kpdsfpa9wf6ijnd8zfbnhmk5pn6jaww";
  buildDepends = [ cereal entropy largeword tagged ];
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
