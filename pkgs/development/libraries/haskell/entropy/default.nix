{ cabal }:

cabal.mkDerivation (self: {
  pname = "entropy";
  version = "0.3";
  sha256 = "0b1yx7409xw8jz2rj8695xscjnw4p7y80niq9cbkqrmnqbqnwj2q";
  meta = {
    homepage = "https://github.com/TomMD/entropy";
    description = "A platform independent entropy source";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
