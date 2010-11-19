{cabal, dataAccessor, utilityHt}:

cabal.mkDerivation (self : {
  pname = "data-accessor-template";
  version = "0.2.1.5";
  sha256 = "0fvf1cacvqzyl9x88h7fa0d6p94qhkvf177a84g036qjxn0khyja";
  propagatedBuildInputs = [dataAccessor utilityHt];
  meta = {
    description = "Utilities for accessing and manipulating the fields of records";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

