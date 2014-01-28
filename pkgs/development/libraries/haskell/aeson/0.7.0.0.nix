{ cabal, attoparsec, deepseq, dlist, hashable, HUnit, mtl
, QuickCheck, scientific, syb, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.7.0.0";
  sha256 = "14xh7i07ha2hgljq0y0v7f5gkn0pv2zqj8l9j92957mf7f17zwf6";
  buildDepends = [
    attoparsec deepseq dlist hashable mtl scientific syb text time
    unorderedContainers vector
  ];
  testDepends = [
    attoparsec HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text time unorderedContainers vector
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
