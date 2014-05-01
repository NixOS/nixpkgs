{ cabal, binary, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "largeword";
  version = "1.2.2";
  sha256 = "04l55q2q8k7q8cz5gwmb9sc211pgqazjwvgs0np1xi9z9d7ylcjg";
  buildDepends = [ binary ];
  testDepends = [
    binary HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/idontgetoutmuch/largeword";
    description = "Provides Word128, Word192 and Word256 and a way of producing other large words if required";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
