{ cabal, Cabal, deepseq, QuickCheck, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.4.1";
  sha256 = "04ndcp7m1a7mia4by15dqrwl5k0d2477x20s6xcrdb7in8w9ccvp";
  buildDepends = [ deepseq ];
  testDepends = [
    Cabal deepseq QuickCheck testFramework testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "http://semantic.org/TimeLib/";
    description = "A time library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
