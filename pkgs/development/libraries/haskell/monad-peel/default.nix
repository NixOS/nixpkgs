{cabal, transformers}:

cabal.mkDerivation (self : {
  pname = "monad-peel";
  version = "0.1";
  sha256 = "0q56hdjgbj7ykpjx5z8qlqqkngmgm5wzm9vwcd7v675k2ywcl3ys";
  propagatedBuildInputs = [transformers];
  meta = {
    description = "Lift control operations like exception catching through monad transformers";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})
