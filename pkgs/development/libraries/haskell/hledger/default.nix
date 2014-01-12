{ cabal, cmdargs, csv, dataPprint, filepath, haskeline, hledgerLib
, HUnit, mtl, parsec, prettyShow, regexpr, safe, shakespeareText
, split, tabular, testFramework, testFrameworkHunit, text, time
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.22.1";
  sha256 = "1mlh5dlbfkqz41i7zaa4cybf75cg5mrp6sj48kwns0liaqyvav58";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs dataPprint filepath haskeline hledgerLib HUnit mtl parsec
    regexpr safe shakespeareText split tabular text time utf8String
  ];
  testDepends = [
    cmdargs csv dataPprint filepath haskeline hledgerLib HUnit mtl
    parsec prettyShow regexpr safe shakespeareText split tabular
    testFramework testFrameworkHunit text time transformers
  ];
  meta = {
    homepage = "http://hledger.org";
    description = "The main command-line interface for the hledger accounting tool";
    license = "GPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
