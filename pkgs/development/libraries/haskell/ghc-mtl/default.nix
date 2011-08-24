{ cabal, MonadCatchIOMtl, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-mtl";
  version = "1.0.1.0";
  sha256 = "5284e0ecf99511e6263503412faf6fa809dc577c009fde63203d46405eb1b191";
  buildDepends = [ MonadCatchIOMtl mtl ];
  meta = {
    homepage = "http://code.haskell.org/~jcpetruzza/ghc-mtl";
    description = "An mtl compatible version of the Ghc-Api monads and monad-transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
