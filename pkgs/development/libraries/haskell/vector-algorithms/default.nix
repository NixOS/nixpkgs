{cabal, primitive, vector}:

cabal.mkDerivation (self : {
  pname = "vector-algorithms";
  version = "0.3.4";
  sha256 = "19b25myz0lhf010lgajlkz72g3w119x89i097rmbc2y4z1bjgpiv";
  propagatedBuildInputs = [primitive vector];
  meta = {
    description = "Efficient algorithms for vector arrays";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

