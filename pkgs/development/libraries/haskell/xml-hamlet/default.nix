{ cabal, parsec, shakespeare, text, xmlConduit }:

cabal.mkDerivation (self: {
  pname = "xml-hamlet";
  version = "0.4.0.3";
  sha256 = "1923c2jg162jab01mcbpy52xs1pzxkrgny6sq8v0p758n8hjazwc";
  buildDepends = [ parsec shakespeare text xmlConduit ];
  meta = {
    homepage = "http://www.yesodweb.com/";
    description = "Hamlet-style quasiquoter for XML content";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
