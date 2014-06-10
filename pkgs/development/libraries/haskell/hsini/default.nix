{ cabal, HUnit, mtl, parsec, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, testFrameworkTh
}:

cabal.mkDerivation (self: {
  pname = "hsini";
  version = "0.3.1";
  sha256 = "06cys4i1nsic13dkp5jgammm3qykzizlnp6wdka2vl699rvnzaaf";
  buildDepends = [ mtl parsec ];
  testDepends = [
    HUnit mtl parsec QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh
  ];
  jailbreak = true;
  meta = {
    description = "Package for user configuration files (INI)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
