{ cabal, aeson, attoparsec, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, httpConduit, httpTypes, network
, tagsoup, text, transformers, unorderedContainers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.0.0";
  sha256 = "0a163dhi69gh6zmi43jidxlaknbk1y0frjlwijdf7fp073rh0p87";
  buildDepends = [
    aeson attoparsec blazeBuilder blazeBuilderConduit caseInsensitive
    conduit httpConduit httpTypes network tagsoup text transformers
    unorderedContainers xmlConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Authentication methods for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
