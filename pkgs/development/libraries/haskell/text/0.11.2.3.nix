{ cabal, deepseq, HUnit, QuickCheck, random, testFramework
, testFrameworkHunit, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "text";
  version = "0.11.2.3";
  sha256 = "0jrl3qbi91gkcnws9crsa59jsmmbjy91fwvl07qka9m48nq3f9rm";
  buildDepends = [ deepseq ];
  testDepends = [
    deepseq HUnit QuickCheck random testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  doCheck = false;
  meta = {
    homepage = "https://github.com/bos/text";
    description = "An efficient packed Unicode text type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
