{ cabal, aeson, attoparsec, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, httpConduit, httpTypes, network
, tagsoup, text, transformers, unorderedContainers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.0.0.1";
  sha256 = "0wrbr7kwd4g8idd6i4ghvpd5q7nq0b8zx5qphqvkbs128m0r308d";
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
