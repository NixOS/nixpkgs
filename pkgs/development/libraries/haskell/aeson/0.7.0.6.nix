{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, HUnit
, mtl, QuickCheck, scientific, syb, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.7.0.6";
  sha256 = "0vsf9msz9iv7xvsnys5c0kbkldb0pvhiai02vz50b0d1kdsk2mb4";
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
