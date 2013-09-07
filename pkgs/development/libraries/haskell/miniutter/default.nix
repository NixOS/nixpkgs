{ cabal, binary, HUnit, minimorph, testFramework
, testFrameworkHunit, text
}:

cabal.mkDerivation (self: {
  pname = "miniutter";
  version = "0.4.2";
  sha256 = "00027aqxa0631v3n1jsv4aj9kf39s5yivi3dl573s5nj0wibj008";
  buildDepends = [ binary minimorph text ];
  testDepends = [ HUnit testFramework testFrameworkHunit text ];
  meta = {
    homepage = "https://github.com/Mikolaj/miniutter";
    description = "Simple English clause creation from arbitrary words";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
