{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, HUnit
, mtl, QuickCheck, scientific, syb, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text, time
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.7.0.1";
  sha256 = "17cwclxh2f2m0mvs867lfzrv14gd9grw8a9f8l95j3nd76y58kb3";
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
