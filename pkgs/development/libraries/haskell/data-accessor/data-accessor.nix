{cabal, transformers}:

cabal.mkDerivation (self : {
  pname = "data-accessor";
  version = "0.2.1.7";
  sha256 = "05wi8wm4vq4j4ldx1925q7v31rnh4gj5891gqc5hdf0x8cgkxbii";
  propagatedBuildInputs = [transformers];
  meta = {
    description = "Utilities for accessing and manipulating the fields of records";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

