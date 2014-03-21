{ cabal, QuickCheck, random, tagged, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-quickcheck";
  version = "0.8";
  sha256 = "10d7chqrlp1fjphnkiykxd22g4mfp69kmihd705sxb0y0mrdfh8x";
  buildDepends = [ QuickCheck random tagged tasty ];
  meta = {
    description = "QuickCheck support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
