{cabal, mtl, happy, gmp, boehmgc}:

cabal.mkDerivation (self : {
  pname = "epic";
  version = "0.1.5";
  sha256 = "5a3d94e88cb85beb3c13f3b9f3c00c6768e1b067ff88d40ea63d9961a92347ff";
  propagatedBuildInputs = [mtl];
  extraBuildInputs = [happy gmp boehmgc];
  meta = {
    description = "An experimental language with full dependent types";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
