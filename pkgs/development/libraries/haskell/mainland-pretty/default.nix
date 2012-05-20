{ cabal, srcloc, symbol }:

cabal.mkDerivation (self: {
  pname = "mainland-pretty";
  version = "0.1.2.0";
  sha256 = "0qhv8qfzcm5n1scgmxsv1c2qqnhvp8r0hmax22vzaq7jmlzwhj4p";
  buildDepends = [ srcloc symbol ];
  meta = {
    homepage = "http://www.eecs.harvard.edu/~mainland/";
    description = "Pretty printing designed for printing source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
