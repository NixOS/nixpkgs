{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "mtl";
  version = "1.1.0.2";
  sha256 = "a225aaf2b1e337f40c31e5c42f95eec9a4608322b0e4c135d2b31b8421a58d36";
  buildDepends = [ Cabal ];
  meta = {
    description = "Monad transformer library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
