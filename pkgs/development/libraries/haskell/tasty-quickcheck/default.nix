{ cabal, QuickCheck, random, tagged, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-quickcheck";
  version = "0.3.1";
  sha256 = "1rajvcq2a1yxdbb4kykvab1p9rnmsd2lgmlk61nd4fxvsvfj5gzn";
  buildDepends = [ QuickCheck random tagged tasty ];
  meta = {
    description = "QuickCheck support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
