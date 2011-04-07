{cabal, mtl, happy, gmp, boehmgc}:

cabal.mkDerivation (self : {
  pname = "epic";
  version = "0.1.10";
  sha256 = "0iaq0mswf370jk4r2xyby8qa5ihcydnbkr478p35x2i56axp60ji";
  propagatedBuildInputs = [mtl];
  extraBuildInputs = [happy gmp boehmgc];
  noHaddock = true;
  meta = {
    description = "An experimental language with full dependent types";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
