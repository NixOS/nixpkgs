{cabal, failure, mtl, transformers, MonadCatchIOMtl, MonadCatchIOTransformers}:

cabal.mkDerivation (self : {
  pname = "neither";
  version = "0.0.2";
  sha256 = "1e1b934d9d1918bd762bb8d6cde35c56883543c2d0c165a661f096c2ce5ab139";
  propagatedBuildInputs = [
    failure mtl transformers MonadCatchIOMtl MonadCatchIOTransformers
  ];
  meta = {
    description = "A simple type class for success/failure computations";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
