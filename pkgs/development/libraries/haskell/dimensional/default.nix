{cabal, numtype}:

cabal.mkDerivation (self : {
  pname = "dimensional";
  version = "0.10";
  sha256 = "5d0ab2a0ca566f7d9a4fe1ec180a1bcf4138a3647a2c287a908506c8911cd385";
  propagatedBuildInputs = [numtype];
  meta = {
    description = "library providing data types for performing arithmetic with physical quantities and units";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.simons];
  };
})
