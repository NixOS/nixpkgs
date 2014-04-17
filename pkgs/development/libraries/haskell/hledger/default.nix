{ cabal, cmdargs, csv, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, prettyShow, regexpr, safe, shakespeareText, split
, tabular, testFramework, testFrameworkHunit, text, time
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.22.2";
  sha256 = "08lk3gd332k5bhvr6db4z66f2rggzbdbhcb03sc5m0dbinawmib8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs filepath haskeline hledgerLib HUnit mtl parsec prettyShow
    regexpr safe shakespeareText split tabular text time utf8String
  ];
  testDepends = [
    cmdargs csv filepath haskeline hledgerLib HUnit mtl parsec
    prettyShow regexpr safe shakespeareText split tabular testFramework
    testFrameworkHunit text time transformers
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
