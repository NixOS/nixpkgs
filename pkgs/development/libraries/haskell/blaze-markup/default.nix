{ cabal, blazeBuilder, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, text
}:

cabal.mkDerivation (self: {
  pname = "blaze-markup";
  version = "0.5.1.5";
  sha256 = "0g3smm1ym7h45bkzx94b77ssyg0z0gqfwbnap3ywa2381rb39l74";
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
