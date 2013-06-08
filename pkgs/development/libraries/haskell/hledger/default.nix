{ cabal, cmdargs, csv, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, prettyShow, regexCompat, regexpr, safe, shakespeareText
, split, testFramework, testFrameworkHunit, text, time
, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.21.2";
  sha256 = "04n9bm97zqh8am83fr2aflw3gv5nwm9jm7bp9vzd4986f1c43ig3";
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
