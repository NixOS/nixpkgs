{cabal, QuickCheck, time}:

cabal.mkDerivation (self : {
  pname = "datetime";
  version = "0.1";
  sha256 = "0j2h369ydmlnkvk6m9j7b6fgs6cyc425s8n3yaajr4j5rdqcq6lk";
  propagatedBuildInputs = [QuickCheck time];
  meta = {
    description = "Utilities to make Data.Time.* easier to use";
  };
})
