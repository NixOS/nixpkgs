{cabal, QuickCheck}:

cabal.mkDerivation (self : {
  pname = "Vec";
  version = "0.9.7";
  sha256 = "a67197f4dc022d6119a790e029a9475a17bb04ad812006bb154e5da9cd8f7ac7";
  propagatedBuildInputs = [QuickCheck];
  meta = {
    description = "Fixed-length lists and low-dimensional linear algebra";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

