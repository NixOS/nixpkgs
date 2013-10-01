{ cabal, HUnit, llvmConfig, mtl, parsec, QuickCheck, setenv
, testFramework, testFrameworkHunit, testFrameworkQuickcheck2, text
, transformers
}:

cabal.mkDerivation (self: {
  pname = "llvm-general";
  version = "3.3.5.0";
  sha256 = "15zrav7339jn6p75g1d7h3qkr1wyal1jzfs8xy73kckw2fzn4nlf";
  buildDepends = [ mtl parsec setenv text transformers ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  buildTools = [ llvmConfig ];
  meta = {
    description = "General purpose LLVM bindings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
