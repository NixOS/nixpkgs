{cabal, hledgerLib, csv, haskeline}:

cabal.mkDerivation (self : {
  pname = "hledger";
  version = "0.14";
  sha256 = "1bfcb1dcc88d8cec924afbf7aefd1ccf88b7be785b522c1595b75b91f8c82d35";
  propagatedBuildInputs = [hledgerLib csv haskeline];
  meta = {
    description = "a reliable, practical financial reporting tool for day-to-day use";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
