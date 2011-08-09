{ cabal }:

cabal.mkDerivation (self: {
  pname = "Tensor";
  version = "1.0.0.1";
  sha256 = "10arhk5gkn5jxpb53r80bblpk0afdax1fc2mik40hj5g5g960cp9";
  meta = {
    homepage = "http://www.haskell.org/HOpenGL/";
    description = "Tensor data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
