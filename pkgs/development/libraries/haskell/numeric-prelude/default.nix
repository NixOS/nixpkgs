{cabal, HUnit, QuickCheck, parsec, nonNegative, utilityHt}:

cabal.mkDerivation (self : {
  pname = "numeric-prelude";
  version = "0.1";
  sha256 = "01de33ea483808704f6d2c635763fcbff3abe12db8035c6640124eb8486b6efb";
  propagatedBuildInputs = [HUnit QuickCheck parsec nonNegative utilityHt];
  meta = {
    description = "An experimental alternative hierarchy of numeric type classes";
  };
})

