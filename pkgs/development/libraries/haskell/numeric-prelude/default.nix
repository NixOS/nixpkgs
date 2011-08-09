{cabal, HUnit, QuickCheck, parsec, nonNegative, utilityHt, storableRecord}:

cabal.mkDerivation (self : {
  pname = "numeric-prelude";
  version = "0.2.2";
  sha256 = "bc6adb8c2f04e0e1f62e183e052974700143dc93b1a3cbafe3562aa1f7a649fd";
  propagatedBuildInputs = [HUnit QuickCheck parsec nonNegative utilityHt storableRecord];
  meta = {
    description = "An experimental alternative hierarchy of numeric type classes";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})

