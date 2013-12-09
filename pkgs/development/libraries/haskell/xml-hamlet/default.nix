{ cabal, hspec, HUnit, parsec, shakespeare, text, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "xml-hamlet";
  version = "0.4.0.6";
  sha256 = "05izdqpxw0gq2wgs4ckr55xvzfk5ay7xpbcvihj66myiah5azqwy";
  buildDepends = [ parsec shakespeare text xmlConduit ];
  testDepends = [ hspec HUnit parsec shakespeare text xmlConduit ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Hamlet-style quasiquoter for XML content";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
