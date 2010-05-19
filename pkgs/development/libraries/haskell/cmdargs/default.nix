{cabal, filepath, mtl}:

cabal.mkDerivation (self : {
  pname = "cmdargs";
  version = "0.1";
  sha256 = "1ec8a0b49dedc0b159c4e8f6b02ae57ba918b27d8648294998a13e04cf257ebf";
  propagatedBuildInputs = [filepath mtl];
  meta = {
    description = "Command line argument processing";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

