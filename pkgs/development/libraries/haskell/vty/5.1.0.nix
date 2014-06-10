{ cabal, blazeBuilder, Cabal, dataDefault, deepseq, filepath
, hashable, HUnit, lens, mtl, parallel, parsec, QuickCheck
, quickcheckAssertions, random, smallcheck, stringQq, terminfo
, testFramework, testFrameworkHunit, testFrameworkSmallcheck, text
, transformers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "5.1.0";
  sha256 = "0cq9y802z9wq69yw1yy916xsz6j7v8208k5mxixp41375cdm141x";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    blazeBuilder dataDefault deepseq filepath hashable lens mtl
    parallel parsec terminfo text transformers utf8String vector
  ];
  testDepends = [
    blazeBuilder Cabal dataDefault deepseq HUnit lens mtl QuickCheck
    quickcheckAssertions random smallcheck stringQq terminfo
    testFramework testFrameworkHunit testFrameworkSmallcheck text
    utf8String vector
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "https://github.com/coreyoconnor/vty";
    description = "A simple terminal UI library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
