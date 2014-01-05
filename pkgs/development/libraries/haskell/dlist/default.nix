{ cabal, Cabal, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "dlist";
  version = "0.6.0.1";
  sha256 = "08q8dsczh59a0ii3nqk6yqz70msd0pndjjcg9dzq8iyknbbqbi45";
  testDepends = [ Cabal QuickCheck ];
  meta = {
    homepage = "https://github.com/spl/dlist";
    description = "Difference lists";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
