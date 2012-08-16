{ cabal, aeson, attoparsec, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, httpConduit, httpTypes, monadControl
, network, resourcet, tagsoup, text, transformers
, unorderedContainers, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.3.0.1";
  sha256 = "12s1ri2k0hmaws1rnr4s8ck1wa14lhcih0pzi89hjh7jh8si3dl3";
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
