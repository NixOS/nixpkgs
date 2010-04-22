{cabal, mtl, parsec, MissingH}:

cabal.mkDerivation (self : {
  pname = "ConfigFile";
  version = "1.0.6";
  sha256 = "339722184b86d53d8b361933e572b6e1478824c7eba3fb66b67d0eb5245cd038";
  propagatedBuildInputs = [mtl parsec MissingH];
  meta = {
    description = "Configuration file reading & writing";
    license = "LGPL";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

