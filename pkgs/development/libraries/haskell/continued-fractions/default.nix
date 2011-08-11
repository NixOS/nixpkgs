{ cabal }:

cabal.mkDerivation (self: {
  pname = "continued-fractions";
  version = "0.9.1.0";
  sha256 = "07g6ms68xfzd25zr2k2fpg4f4pynmq4mn7djkzrg3gbfh9gfq37q";
  meta = {
    homepage = "/dev/null";
    description = "Continued fractions";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
