{ cabal, Cabal, deepseq, QuickCheck, testFramework
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "time";
  version = "1.4.0.2";
  sha256 = "0p4ncankr9968lp4fnbq6pc5xwv2198gxhbds656da9jbv74w7j8";
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
