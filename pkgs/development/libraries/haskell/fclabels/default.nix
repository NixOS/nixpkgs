{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.1.0";
  sha256 = "0wklxzrvnp91qssdxym66xpi20g0dhx4kmww2fhbjjkdc023xd3z";
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
