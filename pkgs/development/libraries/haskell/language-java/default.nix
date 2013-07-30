{ cabal, alex, cpphs, filepath, HUnit, mtl, parsec, QuickCheck, syb
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "language-java";
  version = "0.2.5.1";
  sha256 = "06jzski25840jk3775ia7nx11mjkyp9cmmb7y81djcndliblbyhc";
  buildDepends = [ cpphs parsec syb ];
  testDepends = [
    filepath HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  buildTools = [ alex ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/jkoppel/language-java";
    description = "Manipulating Java source: abstract syntax, lexer, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
