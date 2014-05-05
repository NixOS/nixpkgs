{ cabal, ansiWlPprint, HUnit, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
, testFrameworkThPrime, transformers
}:

cabal.mkDerivation (self: {
  pname = "optparse-applicative";
  version = "0.8.1";
  sha256 = "0zy295r2idrwz030i1slpgysyw08782cjc4vgpkxby8i6piixwlh";
  buildDepends = [ ansiWlPprint transformers ];
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkThPrime
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/pcapriotti/optparse-applicative";
    description = "Utilities and combinators for parsing command line options";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
