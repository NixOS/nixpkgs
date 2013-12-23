{ cabal, attoparsec, blazeBuilder, deepseq, filepath, HUnit, mtl
, network, primitive, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time, transformers, vector, zlib
, zlibBindings
}:

cabal.mkDerivation (self: {
  pname = "io-streams";
  version = "1.1.2.2";
  sha256 = "1miq7sbvbsi6wi3siqr8w8d21v7x4axs0yrcd816xnjnjw19082j";
  buildDepends = [
    attoparsec blazeBuilder network primitive text time transformers
    vector zlibBindings
  ];

  enableCheckPhase = false;
  doCheck = false;
  checkPhase = "";

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
  };
})
