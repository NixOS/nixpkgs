{ cabal, HUnit, csv, haskeline, hledgerLib, mtl, parsec, regexpr
, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.14";
  sha256 = "1bfcb1dcc88d8cec924afbf7aefd1ccf88b7be785b522c1595b75b91f8c82d35";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    HUnit csv haskeline hledgerLib mtl parsec regexpr safe split time
    utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "A robust command-line accounting tool with a simple human-editable data format, similar to ledger";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
