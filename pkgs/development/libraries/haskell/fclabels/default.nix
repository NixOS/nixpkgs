{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.1.0.1";
  sha256 = "0nzqx1d4hwailfkcb9g03hagws9j6valqd5yp7972kmhbq0c8h3s";
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
