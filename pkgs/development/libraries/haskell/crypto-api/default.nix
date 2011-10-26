{ cabal, cereal, entropy, largeword, tagged }:

cabal.mkDerivation (self: {
  pname = "crypto-api";
  version = "0.8";
  sha256 = "1fwkafb9v2348vr1a4xnlmkgs4kh85az4f3wnrl9cbqwxf3cc328";
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
