{ cabal, Cabal, cmdargs, filepath, HUnit, mtl, parsec, regexpr
, safe, split, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.17";
  sha256 = "0dlm3hjbcf48nzz597ag1q9y0phsc09062wvzpmfkhk4hsijpds4";
  buildDepends = [
    Cabal cmdargs filepath HUnit mtl parsec regexpr safe split time
    utf8String
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "Core data types, parsers and utilities for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
