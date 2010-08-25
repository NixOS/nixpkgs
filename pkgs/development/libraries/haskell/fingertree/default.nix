{cabal}:

cabal.mkDerivation (self : {
  pname = "fingertree";
  version = "0.0.1.0";
  sha256 = "e80bf256506290c8f4fb44222920ae7d8405fd22e453c7a08dba49297d49328b";
  meta = {
    description = "Generic finger-tree structure, with example instances";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

