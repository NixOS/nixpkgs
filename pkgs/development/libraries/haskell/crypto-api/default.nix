{cabal, cereal, entropy, largeword, tagged} :

cabal.mkDerivation (self : {
  pname = "crypto-api";
  version = "0.6.4";
  sha256 = "1v3nnfw13r514a723lsx8d1awlad6fmv27bgp76f1ssv1garraf3";
  propagatedBuildInputs = [ cereal entropy largeword tagged ];
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
