{cabal, primitive}:

cabal.mkDerivation (self : {
  pname = "vector";
  version = "0.6.0.1";
  sha256 = "b0cba9b3aa94688321a2ec7b4fb4b41781073b2605584ad41957ba1c6892acce";
  propagatedBuildInputs = [primitive];
  meta = {
    description = "Efficient arrays";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

