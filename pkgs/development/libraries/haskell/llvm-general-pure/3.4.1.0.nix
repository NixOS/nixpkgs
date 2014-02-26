{ cabal, HUnit, mtl, parsec, QuickCheck, setenv, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "llvm-general-pure";
  version = "3.4.1.0";
  sha256 = "0cjzqw9k6x8akbgx4rdigvhjhfv9zlq40p789invdc514qmxhr6q";
  buildDepends = [ mtl parsec setenv transformers ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    description = "Pure Haskell LLVM functionality (no FFI)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
