{ cabal, cereal, entropy, tagged, transformers }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.11";
  sha256 = "1v42dmm4cx8brb5mpz34wa20c3s27r0v7qiqlb54svzsl0jkfmiy";
  buildDepends = [ cereal entropy tagged transformers ];
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
