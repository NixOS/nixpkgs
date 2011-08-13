{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.0";
  sha256 = "0mc5lbpgyf8m1rpfszj61yhjddxbgk28rx71321jrfqsrzynf4h5";
  buildDepends = [ mtl transformers ];
  meta = {
    description = "First class accessor labels";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
