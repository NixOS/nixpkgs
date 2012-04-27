{ cabal, cereal, entropy, largeword, tagged }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.10.2";
  sha256 = "06dbvdwyw2hf5cafpjfhasgyzzbigvvg74c47lafvqvgxvn9v4ms";
  buildDepends = [ cereal entropy largeword tagged ];
  meta = {
    homepage = "http://trac.haskell.org/crypto-api/wiki";
    description = "A generic interface for cryptographic operations";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
