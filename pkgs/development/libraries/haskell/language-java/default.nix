{ cabal, alex, cpphs, filepath, HUnit, mtl, parsec, QuickCheck, syb
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "language-java";
  version = "0.2.4";
  sha256 = "1fb36xq75mzmbsh25s0pscazvz6nvfy2mn1270653m7s3gdgcs5f";
  buildDepends = [ cpphs parsec syb ];
  testDepends = [
    filepath HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  buildTools = [ alex ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/vincenthz/language-java";
    description = "Manipulating Java source: abstract syntax, lexer, parser, and pretty-printer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
