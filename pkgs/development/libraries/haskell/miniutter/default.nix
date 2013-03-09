{ cabal, HUnit, minimorph, testFramework, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "miniutter";
  version = "0.4.0";
  sha256 = "1l275aad8svrqp22jv9s0mmlam7wbdlf6m4m97658rm8ks4j2mbx";
  buildDepends = [ minimorph text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "https://github.com/Mikolaj/miniutter";
    description = "Simple English clause creation from arbitrary words";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
