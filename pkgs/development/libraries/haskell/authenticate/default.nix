{ cabal, aeson, attoparsec, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, httpConduit, httpTypes, monadControl
, network, resourcet, tagsoup, text, transformers
, unorderedContainers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.3.2.4";
  sha256 = "1xakp54g5dyppzpm1q3bbx6g4pvs7p2903pyq6bya1n82zsk7yg7";
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
