{cabal, deepseq, HUnit}:

cabal.mkDerivation (self : {
  pname = "monad-par";
  version = "0.1.0.1";
  sha256 = "0sd5w09vi12jwzz8xgh51r27577byr6pqp15dw0z5nhf4w869qxq";
  propagatedBuildInputs = [deepseq HUnit];
  meta = {
    description = "A library for parallel programming based on a monad";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
