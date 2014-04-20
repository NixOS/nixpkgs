{ cabal, blazeBuilder, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.6.0.0";
  sha256 = "1f54i570cqbyqkrsq4qd2bky88pdwg9lv84c6aaf2c21552dbvii";
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
