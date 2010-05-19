{cabal}:

cabal.mkDerivation (self : {
  pname = "primitive";
  version = "0.3";
  sha256 = "b63cb5dd3417433429b3ad5489791bddd0973b96b7c3314a4ecc9e6a68b2a35d";
  meta = {
    description = "Wrappers for primitive operations";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

