{ cabal, HUnit, testFramework, testFrameworkHunit, text }:

cabal.mkDerivation (self: {
  pname = "minimorph";
  version = "0.1.4.0";
  sha256 = "16ri9hfriszrgqcm111b1pp5x65s034hrc35kjz5qax32mnc9rn6";
  buildDepends = [ text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "http://darcsden.com/kowey/minimorph";
    description = "English spelling functions with an emphasis on simplicity";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
