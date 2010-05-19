{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "parsec";
  version = "3.1.0";
  sha256 = "962d39944bae18b0fea60961c77513f455f95c0f67ae4b10ab15484a27b6fb98";
  propagatedBuildInputs = [mtl];
  meta = {
    license = "BSD";
    description = "Monadic parser combinators";
    maintainer = [self.stdenv.lib.maintainers.andres];
  };
})

