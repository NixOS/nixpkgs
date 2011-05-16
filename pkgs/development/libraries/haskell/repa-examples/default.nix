{cabal, repa, repaAlgorithms, repaIO, vector, llvm}:

cabal.mkDerivation (self : {
  pname = "repa-examples";
  version = "2.0.0.3";
  sha256 = "0kj93rrr63x34dcljw6hvqjbz4mfzw00gmbddrqya0dhf9ifjnb9";
  extraBuildInputs = [llvm];
  propagatedBuildInputs = [repa repaAlgorithms repaIO vector];
  meta = {
    description = "Examples using the Repa array library";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

