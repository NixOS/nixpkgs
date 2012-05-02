{ cabal }:

cabal.mkDerivation (self: {
  pname = "continued-fractions";
  version = "0.9.1.1";
  sha256 = "0gqp1yazmmmdf04saa306jdsf8r5s98fll9rnm8ff6jzr87nvnnh";
  meta = {
    homepage = "/dev/null";
    description = "Continued fractions";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
