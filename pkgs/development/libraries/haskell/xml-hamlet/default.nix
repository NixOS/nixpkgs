{ cabal, hspec, HUnit, parsec, shakespeare, text, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "xml-hamlet";
  version = "0.4.0.5";
  sha256 = "1w1ixjdbpbny332j24d5yjxc4i7cg83jc4yjdm6yl94y1sr90yc5";
  buildDepends = [ parsec shakespeare text xmlConduit ];
  testDepends = [ hspec HUnit parsec shakespeare text xmlConduit ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Hamlet-style quasiquoter for XML content";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
