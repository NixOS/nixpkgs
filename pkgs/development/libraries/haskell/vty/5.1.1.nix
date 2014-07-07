{ cabal, blazeBuilder, Cabal, dataDefault, deepseq, filepath
, hashable, HUnit, lens, mtl, parallel, parsec, QuickCheck
, quickcheckAssertions, random, smallcheck, stringQq, terminfo
, testFramework, testFrameworkHunit, testFrameworkSmallcheck, text
, transformers, utf8String, vector
}:

cabal.mkDerivation (self: {
  pname = "vty";
  version = "5.1.1";
  sha256 = "043vrazb8w6ljq14i390cwcmavgmbnjbs6sl6w0yx8cwb4f7djr5";
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
