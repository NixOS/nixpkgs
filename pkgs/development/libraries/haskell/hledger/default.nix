{ cabal, cmdargs, csv, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, prettyShow, regexCompat, regexpr, safe, shakespeareText
, split, testFramework, testFrameworkHunit, text, time
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.21.3";
  sha256 = "14j0axlq6xfaih7m6lqpis26ya0yl4v6g6xrqbihmjddvx7j32f2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs filepath haskeline hledgerLib HUnit mtl parsec regexpr safe
    shakespeareText split text time utf8String
  ];
  testDepends = [
    cmdargs csv filepath haskeline hledgerLib HUnit mtl parsec
    prettyShow regexCompat regexpr safe shakespeareText split
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
