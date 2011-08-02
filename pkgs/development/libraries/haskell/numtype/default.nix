{cabal}:

cabal.mkDerivation (self : {
  pname = "numtype";
  version = "1.0";
  sha256 = "2606e81d7bcef0ba76b1e6ffc8d513c36fef5fefaab3bdd02da18761ec504e1f";
  meta = {
    description = "unary type level representations of the (positive and negative) integers";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.simons];
  };
})
