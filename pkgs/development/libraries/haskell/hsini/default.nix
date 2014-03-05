{ cabal, HUnit, mtl, parsec, QuickCheck, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, testFrameworkTh
}:

cabal.mkDerivation (self: {
  pname = "hsini";
  version = "0.2";
  sha256 = "0d9dhzaw2v9r0hb4lywzw4f0inijbcw5brc5dh45zfkalmn3aqam";
  buildDepends = [ mtl parsec ];
  testDepends = [
    HUnit mtl parsec QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh
  ];
  doCheck = false;
  meta = {
    description = "Package for user configuration files (INI)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
