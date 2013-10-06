{ cabal, HUnit, llvmConfig, llvmGeneralPure, mtl, parsec
, QuickCheck, setenv, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2, transformers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "llvm-general";
  version = "3.3.8.2";
  sha256 = "11qnvpnx4i8mjdgn5y58rl70wf8pzmd555hrdaki1f4q0035cmm5";
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
