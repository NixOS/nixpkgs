{ cabal }:

cabal.mkDerivation (self: {
  pname = "xml";
  version = "1.3.9";
  sha256 = "1sx6k5dscpcy4aq09g7h0fz0sl4w2nrr4pnklgwrbrh6bf6kc6w2";
  meta = {
    homepage = "http://code.galois.com";
    description = "A simple XML library.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
