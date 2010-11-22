{cabal, transformers}:

cabal.mkDerivation (self : {
  pname = "data-accessor";
  version = "0.2.1.4";
  sha256 = "1fnfbcw1fzas2sbk9yhwd05ncvgqfy47hi9xh0ygsqilx7nwkdxv";
  propagatedBuildInputs = [transformers];
  meta = {
    description = "Utilities for accessing and manipulating the fields of records";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

