{ cabal, attoparsec, blazeBuilder, deepseq, filepath, HUnit, mtl
, network, primitive, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time, transformers, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "io-streams";
  version = "1.1.4.2";
  sha256 = "0x6d0j41wnxl2h9xzbybmzqrrna3hc17786k65cpiby2x3nlp799";
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
