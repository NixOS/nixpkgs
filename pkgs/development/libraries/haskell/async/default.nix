{ cabal, stm }:

cabal.mkDerivation (self: {
  pname = "async";
  version = "2.0.1.0";
  sha256 = "00yfxp18zhfjnxz0bqzym0ikarzsa75yw5pi33dsyv9kivra3k5q";
  buildDepends = [ stm ];
  meta = {
    homepage = "https://github.com/simonmar/async";
    description = "Run IO operations asynchronously and wait for their results";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
