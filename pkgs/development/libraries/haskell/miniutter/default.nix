{ cabal, binary, HUnit, minimorph, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "miniutter";
  version = "0.4.3.0";
  sha256 = "0hslks4vr1738pczgzzcl0mrb9jqs1986vjgw4xpvzz9p3ki1n50";
  buildDepends = [ binary minimorph text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "https://github.com/Mikolaj/miniutter";
    description = "Simple English clause creation from arbitrary words";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
