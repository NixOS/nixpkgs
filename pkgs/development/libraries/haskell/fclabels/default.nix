{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.0.3";
  sha256 = "0sl45pv18qfyphixl9qyng5m6i19c9n18izkm278z6fvih2x5wd0";
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
