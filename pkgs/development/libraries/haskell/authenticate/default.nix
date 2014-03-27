{ cabal, aeson, attoparsec, blazeBuilder, caseInsensitive, conduit
, httpConduit, httpTypes, network, tagstreamConduit, text
, transformers, unorderedContainers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.3.2.7";
  sha256 = "1b7bshbjg2141bywjiw69x1x6k30hx9gcqzjaqy7r1jfhnwcjz43";
  buildDepends = [
    aeson attoparsec blazeBuilder caseInsensitive conduit httpConduit
    httpTypes network tagstreamConduit text transformers
    unorderedContainers xmlConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Authentication methods for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
