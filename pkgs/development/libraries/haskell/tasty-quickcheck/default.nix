{ cabal, QuickCheck, tagged, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-quickcheck";
  version = "0.8.0.3";
  sha256 = "0dng415dsdg86rliwmz5hpn2111cn0x494c0vmdmzv5qgvx5naf6";
  buildDepends = [ QuickCheck tagged tasty ];
  meta = {
    description = "QuickCheck support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
