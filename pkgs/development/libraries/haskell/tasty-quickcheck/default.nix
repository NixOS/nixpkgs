{ cabal, QuickCheck, tagged, tasty }:

cabal.mkDerivation (self: {
  pname = "tasty-quickcheck";
  version = "0.8.1";
  sha256 = "1diqc5dmddrfc6i0zqkmlnnhsv8paqy2fdmbx8484qa4ylk5r6bs";
  buildDepends = [ QuickCheck tagged tasty ];
  meta = {
    description = "QuickCheck support for the Tasty test framework";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
