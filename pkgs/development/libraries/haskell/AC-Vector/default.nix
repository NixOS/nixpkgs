{ cabal }:

cabal.mkDerivation (self: {
  pname = "AC-Vector";
  version = "2.3.1";
  sha256 = "0nmj57czqcik23j9iqxbdwqg73n5n1kc9akhp0wywrbkklgf79a0";
  meta = {
    description = "Efficient geometric vectors and transformations.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
