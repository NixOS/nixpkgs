{cabal}:

cabal.mkDerivation (self : {
  pname = "safe";
  version = "0.2";
  sha256 = "73b9a247c3ba8092236c8c912687399778ff31bf3df42d707563a1528a6fc0e0";
  meta = {
    description = "Library for safe (pattern match free) functions";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

