{ cabal, aeson, attoparsec, blazeBuilder, caseInsensitive, conduit
, httpConduit, httpTypes, monadControl, network, resourcet
, tagstreamConduit, text, transformers, unorderedContainers
, xmlConduit
}:

cabal.mkDerivation (self: {
  pname = "authenticate";
  version = "1.3.2.8";
  sha256 = "1ylijkj32li9nm4x16d66h6a74q07m4v3n2dqm67by548wfyh1j9";
  buildDepends = [
    aeson attoparsec blazeBuilder caseInsensitive conduit httpConduit
    httpTypes monadControl network resourcet tagstreamConduit text
    transformers unorderedContainers xmlConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/authenticate";
    description = "Authentication methods for Haskell web applications";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
