{ cabal, cmdargs, csv, filepath, haskeline, hledgerLib, HUnit, mtl
, parsec, prettyShow, regexpr, safe, shakespeare, shakespeareText
, split, tabular, testFramework, testFrameworkHunit, text, time
, transformers, utf8String, wizards
}:

cabal.mkDerivation (self: {
  pname = "hledger";
  version = "0.23";
  sha256 = "1cylviyz3n6kcsdcr1vx699v6fn1878n4z8y8cnxawq2daz4xhpk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cmdargs filepath haskeline hledgerLib HUnit mtl parsec prettyShow
    regexpr safe shakespeare shakespeareText split tabular text time
    utf8String wizards
  ];
  testDepends = [
    cmdargs csv filepath haskeline hledgerLib HUnit mtl parsec
    prettyShow regexpr safe shakespeare shakespeareText split tabular
    testFramework testFrameworkHunit text time transformers wizards
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
