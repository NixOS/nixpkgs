{ cabal, hspec, HUnit, parsec, shakespeare, text, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "xml-hamlet";
  version = "0.4.0.4";
  sha256 = "1s4s5z1xir9zmcbfz8mrznf2byclmg0qjjhwmpal2r9ly9g3na98";
  buildDepends = [ parsec shakespeare text xmlConduit ];
  testDepends = [ hspec HUnit parsec shakespeare text xmlConduit ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Hamlet-style quasiquoter for XML content";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
