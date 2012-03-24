{ cabal }:

cabal.mkDerivation (self: {
  pname = "numtype";
  version = "1.0";
  sha256 = "2606e81d7bcef0ba76b1e6ffc8d513c36fef5fefaab3bdd02da18761ec504e1f";
  meta = {
    homepage = "http://dimensional.googlecode.com/";
    description = "Type-level (low cardinality) integers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
