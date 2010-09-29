{cabal, mtl, parsec, readline, ivor, epic, happy}:

cabal.mkDerivation (self : {
  pname = "idris";
  name = self.fname;
  version = "0.1.5";
  sha256 = "8acdfc22ba2e68b6c1832c2d5fcf11405df9416ba2c193f564b6f98710e9813e";
  propagatedBuildInputs = [mtl parsec readline ivor epic];
  extraBuildInputs = [happy];
  meta = {
    description = "An experimental language with full dependent types";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
