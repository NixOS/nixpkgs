{ cabal, attoparsec, blazeBuilder, deepseq, filepath, HUnit, mtl
, network, primitive, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time, transformers, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "io-streams";
  version = "1.1.3.0";
  sha256 = "1vw9znmnl9syfgr3rplf7fa57qgmjgf8n1kh3ffiqkgrdpif6p9c";
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
  meta = {
    description = "Simple, composable, and easy-to-use stream I/O";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
  configureFlags = "-fNoInteractiveTests";
})
