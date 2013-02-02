{ cabal, aeson, attoparsec, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, httpConduit, httpTypes, monadControl
, network, resourcet, tagsoup, text, transformers
, unorderedContainers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.3.2.1";
  sha256 = "1r53mnj4b4x0prcqqf6y3gdia2j1l3155iw79jzlx0cnxbdsfnc7";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeBuilderConduit caseInsensitive
    conduit httpConduit httpTypes monadControl network resourcet
    tagsoup text transformers unorderedContainers xmlConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Authentication methods for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
