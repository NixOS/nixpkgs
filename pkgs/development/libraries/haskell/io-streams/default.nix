{ cabal, attoparsec, blazeBuilder, deepseq, filepath, HUnit, mtl
, network, primitive, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time, transformers, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "io-streams";
  version = "1.1.4.5";
  sha256 = "1w76p9hb83x2fjlldcnbk3zddaph4cccka2g13b1rcjssqgnbk8h";
  buildDepends = [
    attoparsec blazeBuilder network primitive text time transformers
    vector zlibBindings
  ];
  testDepends = [
    attoparsec blazeBuilder deepseq filepath HUnit mtl network
    primitive QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text time transformers vector zlib
    zlibBindings
  ];
  configureFlags = "-fNoInteractiveTests";
  meta = {
    description = "Simple, composable, and easy-to-use stream I/O";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
