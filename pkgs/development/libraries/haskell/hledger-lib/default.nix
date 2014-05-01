{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, prettyShow
, regexpr, regexTdfa, safe, split, testFramework
, testFrameworkHunit, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.23";
  sha256 = "1zyg4py321lvgy1al4flyxrmsz0vj8z2y99v9k5fa8s8rfa1qxvl";
  buildDepends = [
    cmdargs csv filepath HUnit mtl parsec prettyShow regexpr regexTdfa
    safe split time transformers utf8String
  ];
  testDepends = [
    cmdargs csv filepath HUnit mtl parsec prettyShow regexpr regexTdfa
    safe split testFramework testFrameworkHunit time transformers
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
