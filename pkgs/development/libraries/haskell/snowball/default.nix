{ cabal, HUnit, QuickCheck, quickcheckInstances, testFrameworkHunit
, testFrameworkQuickcheck2, testFrameworkTh, text, textIcu
}:

cabal.mkDerivation (self: {
  pname = "snowball";
  version = "1.0.0.1";
  sha256 = "0fvxzm14ffjqq6n51bi5cmq5yrlggpkbb9rbbw522l6cjgv0apbx";
  buildDepends = [ text textIcu ];
  testDepends = [
    HUnit QuickCheck quickcheckInstances testFrameworkHunit
    testFrameworkQuickcheck2 testFrameworkTh text
  ];
  doCheck = false;
  meta = {
    homepage = "http://hub.darcs.net/dag/snowball";
    description = "Bindings to the Snowball library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
