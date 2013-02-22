{ cabal, aeson, attoparsec, blazeBuilder, caseInsensitive, conduit
, httpConduit, httpTypes, network, tagsoup, text, transformers
, unorderedContainers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.3.2.6";
  sha256 = "12sgi6q6kajjhh8mns9nklxj0kwn32xs5kzi7wmw50shx0smnjrz";
  buildDepends = [
    aeson attoparsec blazeBuilder caseInsensitive conduit httpConduit
    httpTypes network tagsoup text transformers unorderedContainers
    xmlConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Authentication methods for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
