{cabal, dataAccessor, utilityHt}:

cabal.mkDerivation (self : {
  pname = "data-accessor-template";
  version = "0.2.1.7";
  sha256 = "08658axzznqxp4p4d6h0y0sp7rzj84ma6hrb4zvsxa3614vydgi4";
  propagatedBuildInputs = [dataAccessor utilityHt];
  meta = {
    description = "Utilities for accessing and manipulating the fields of records";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

