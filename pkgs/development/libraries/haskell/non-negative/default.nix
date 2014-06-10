{ cabal, QuickCheck, utilityHt }:

cabal.mkDerivation (self: {
  pname = "non-negative";
  version = "0.1.1";
  sha256 = "163g3j3xrx1jkrbg2wnha3yyxyg1mn7kabmbpg82y3rbl3ihy1p7";
  buildDepends = [ QuickCheck utilityHt ];
  testDepends = [ QuickCheck utilityHt ];
  meta = {
    homepage = "http://code.haskell.org/~thielema/non-negative/";
    description = "Non-negative numbers";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
