{ cabal, HUnit, mtl, parsec, QuickCheck, setenv, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2, transformers
}:

cabal.mkDerivation (self: {
  pname = "llvm-general-pure";
  version = "3.3.8.1";
  sha256 = "1izn30pka7z60dr73c3mhr5i8n2fb0yvpdgg66r7c5qf1m5bmqbx";
  buildDepends = [ mtl parsec setenv transformers ];
  testDepends = [
    HUnit mtl QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    description = "Pure Haskell LLVM functionality (no FFI)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
