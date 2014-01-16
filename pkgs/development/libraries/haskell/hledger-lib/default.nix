{ cabal, cmdargs, csv, dataPprint, filepath, HUnit, mtl, parsec
, prettyShow, regexpr, regexTdfa, safe, split, testFramework
, testFrameworkHunit, time, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger-lib";
  version = "0.22.1";
  sha256 = "0kaa778swx4vw0rkhxd3h9h9qj13rzz24x92z139vad1n722gcw1";
  buildDepends = [
    cmdargs csv dataPprint filepath HUnit mtl parsec prettyShow regexpr
    regexTdfa safe split time transformers utf8String
  ];
  testDepends = [
    cmdargs csv dataPprint filepath HUnit mtl parsec prettyShow regexpr
    regexTdfa safe split testFramework testFrameworkHunit time
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
