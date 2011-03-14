{cabal}:

cabal.mkDerivation (self : {
  pname = "safe";
  version = "0.3";
  sha256 = "174jm7nlqsgvc6namjpfknlix6yy2sf9pxnb3ifznjvx18kgc7m0";
  meta = {
    description = "Library for safe (pattern match free) functions";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

