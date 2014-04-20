{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, HUnit
, mtl, QuickCheck, scientific, syb, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.7.0.2";
  sha256 = "0li89xs4dlwc3ijs6w5gabjibj09x12qgxhzp7mch6gxjxwd3ihj";
  buildDepends = [
    attoparsec blazeBuilder deepseq dlist hashable mtl scientific syb
    text time unorderedContainers vector
  ];
  testDepends = [
    attoparsec HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text time unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/bos/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
