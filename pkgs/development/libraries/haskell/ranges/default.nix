{ cabal }:

cabal.mkDerivation (self: {
  pname = "ranges";
  version = "0.2.4";
  sha256 = "1ymvmvfvzkdxblg691g9n5y94gpiz782jgyvaisg5mydzj1s1fyv";
  meta = {
    description = "Ranges and various functions on them";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
