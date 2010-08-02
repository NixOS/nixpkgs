{cabal, mtl}:

cabal.mkDerivation (self : {
  pname = "QuickCheck";
  version = "2.1.1.1"; # Haskell Platform 2010.2.0.0
  sha256 = "626a6f7a69e2bea3b4fe7c573d0bc8da8c77f97035cb2d3a5e1c9fca382b59c9";
  propagatedBuildInputs = [mtl];
  meta = {
    description = "Automatic testing of Haskell programs";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

