{ cabal }:

cabal.mkDerivation (self: {
  pname = "bimap";
  version = "0.2.4";
  sha256 = "d991ae393ade2191f42d8a0d659d2b9a749675735eb5b57872f577ede82565c5";
  meta = {
    homepage = "http://code.haskell.org/bimap";
    description = "Bidirectional mapping between two key types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
