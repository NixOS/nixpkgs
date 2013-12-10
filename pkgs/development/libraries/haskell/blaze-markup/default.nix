{ cabal, blazeBuilder, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.5.1.6";
  sha256 = "09w0mwws1xz0h0h99n6ppbdycnrv5y74x6asgzvrzqaslrp5rhvm";
  buildDepends = [ blazeBuilder text ];
  testDepends = [
    blazeBuilder HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 text
  ];
  meta = {
    homepage = "http://jaspervdj.be/blaze";
    description = "A blazingly fast markup combinator library for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
