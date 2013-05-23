{ cabal, MonadCatchIOMtl, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-mtl";
  version = "1.0.1.2";
  sha256 = "06m8ynqlbvvs37w211ikldwvlvg4ry27x9l7idnwa1m8w2jkbkva";
  buildDepends = [ MonadCatchIOMtl mtl ];
  meta = {
    homepage = "http://darcsden.com/jcpetruzza/ghc-mtl";
    description = "An mtl compatible version of the Ghc-Api monads and monad-transformers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
