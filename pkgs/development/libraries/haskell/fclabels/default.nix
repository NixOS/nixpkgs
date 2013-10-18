{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "2.0";
  sha256 = "1zh8hr0nq7vnp0q5yf0qd4sbxpaq67l15gs1rvssxfj6n738kngq";
  buildDepends = [ mtl transformers ];
  meta = {
    homepage = "https://github.com/sebastiaanvisser/fclabels";
    description = "First class accessor labels implemented as lenses";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
