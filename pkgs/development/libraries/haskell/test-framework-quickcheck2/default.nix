{ cabal, extensibleExceptions, QuickCheck, random, testFramework }:

cabal.mkDerivation (self: {
  pname = "test-framework-quickcheck2";
  version = "0.3.0.2";
  sha256 = "0zgsbmxidyv735jbgajczn25pnhwq66haaadhh6lxj2jsq5fnqpy";
  buildDepends = [
    extensibleExceptions QuickCheck random testFramework
  ];
  jailbreak = true;
  meta = {
    homepage = "https://batterseapower.github.io/test-framework/";
    description = "QuickCheck2 support for the test-framework package";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
