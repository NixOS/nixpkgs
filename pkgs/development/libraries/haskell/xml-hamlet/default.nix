{ cabal, hspec, HUnit, parsec, shakespeare, text, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "xml-hamlet";
  version = "0.4.0.7";
  sha256 = "05rygs3ja3zc87az151mkbm4llrnshzrqf1mfpbwx4ysfgjkvq7b";
  buildDepends = [ parsec shakespeare text xmlConduit ];
  testDepends = [ hspec HUnit parsec shakespeare text xmlConduit ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Hamlet-style quasiquoter for XML content";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
