{ cabal, MonadCatchIOMtl, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-mtl";
  version = "1.0.1.1";
  sha256 = "04lm1g27xwwph02k3d8b51nbhi2sw8jx7arqczcqc3rygak10fpn";
  buildDepends = [ MonadCatchIOMtl mtl ];
  meta = {
    homepage = "http://darcsden.com/jcpetruzza/ghc-mtl";
    description = "An mtl compatible version of the Ghc-Api monads and monad-transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
