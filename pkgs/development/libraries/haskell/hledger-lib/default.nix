{ cabal, cmdargs, csv, filepath, HUnit, mtl, parsec, prettyShow
, regexCompat, regexpr, safe, split, testFramework
, testFrameworkHunit, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.21";
  sha256 = "1j57f05ja8v2igykij3vnvl4z89cppnnbf9bz1i3m7c61xapawg7";
  buildDepends = [
    cmdargs csv filepath HUnit mtl parsec prettyShow regexCompat
    regexpr safe split time transformers utf8String
  ];
  testDepends = [
    cmdargs csv filepath HUnit mtl parsec prettyShow regexCompat
    regexpr safe split testFramework testFrameworkHunit time
    transformers
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
