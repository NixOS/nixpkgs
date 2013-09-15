{ cabal, HUnit, llvmConfig, llvmGeneralPure, mtl, parsec
, QuickCheck, setenv, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "llvm-general";
  version = "3.3.8.1";
  sha256 = "1w9wqi9mj673s0bm3j4a5kapl5f65sy8mwjbw7ydism6j5jmxhpk";
  buildDepends = [
    llvmGeneralPure mtl parsec setenv transformers utf8String
  ];
  testDepends = [
    HUnit llvmGeneralPure mtl QuickCheck testFramework
    testFrameworkHunit testFrameworkQuickcheck2
  ];
  buildTools = [ llvmConfig ];
  meta = {
    description = "General purpose LLVM bindings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
