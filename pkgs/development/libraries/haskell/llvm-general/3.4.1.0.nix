{ cabal, HUnit, llvmConfig, llvmGeneralPure, mtl, parsec
, QuickCheck, setenv, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "llvm-general";
  version = "3.4.1.0";
  sha256 = "0vh0bqkkahafhiv1sqvrncxswvz4rvb2zfwf33936fnnh5vn8vyp";
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
