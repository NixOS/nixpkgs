{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "2.0.1";
  sha256 = "0gx0vqdxx797zh69xy2s62kyfsp9m48dfpbjykllg4fsk0x60wav";
  buildDepends = [ mtl transformers ];
  meta = {
    homepage = "https://github.com/sebastiaanvisser/fclabels";
    description = "First class accessor labels implemented as lenses";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
