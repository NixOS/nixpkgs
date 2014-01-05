{ cabal, HUnit, QuickCheck, testFramework, testFrameworkHunit
, testFrameworkQuickcheck2
}:

cabal.mkDerivation (self: {
  pname = "extensible-effects";
  version = "1.2.1";
  sha256 = "066977hjhcg44v47hkjpf2gs48xsry74l4h8hp753jsvbfsv0030";
  testDepends = [
    HUnit QuickCheck testFramework testFrameworkHunit
    testFrameworkQuickcheck2
  ];
  meta = {
    homepage = "https://github.com/RobotGymnast/extensible-effects";
    description = "An Alternative to Monad Transformers";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
