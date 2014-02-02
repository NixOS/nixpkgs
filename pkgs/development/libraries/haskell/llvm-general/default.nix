{ cabal, HUnit, llvmConfig, llvmGeneralPure, mtl, parsec
, QuickCheck, setenv, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "llvm-general";
  version = "3.4.0.0";
  sha256 = "1hj96wkgdqyvckgmk7r43n9s9fcq4gijnv0ghrj92ggd13hhmv7b";
  buildDepends = [
    llvmGeneralPure mtl parsec setenv transformers utf8String
  ];
  testDepends = [
    HUnit llvmGeneralPure mtl QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  buildTools = [ llvmConfig ];
  doCheck = false;
  meta = {
    description = "General purpose LLVM bindings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
