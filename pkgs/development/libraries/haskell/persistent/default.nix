{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, liftedBase, monadControl, pathPieces
, poolConduit, resourcet, sqlite, text, time, transformers
, transformersBase, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.9.0.4";
  sha256 = "1igml2hmc8ga9871dfq4mxqvy639vvlgl3cs48j3b27ci3qwd9jr";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml blazeMarkup conduit
    liftedBase monadControl pathPieces poolConduit resourcet text time
    transformers transformersBase unorderedContainers vector
  ];
  extraLibraries = [ sqlite ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, multi-backend data serialization";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
