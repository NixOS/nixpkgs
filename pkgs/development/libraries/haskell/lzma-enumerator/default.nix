{ cabal, bindingsDSL, enumerator, HUnit, lzma, mtl, QuickCheck
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "lzma-enumerator";
  version = "0.1.3";
  sha256 = "0pzz8bf6310p23pmsa013i8vib0xsfvlkj7zp0w9xs2xsi4j7jk1";
  buildDepends = [ bindingsDSL enumerator mtl ];
  testDepends = [
    enumerator HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  extraLibraries = [ lzma ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/alphaHeavy/lzma-enumerator";
    description = "Enumerator interface for lzma/xz compression";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
