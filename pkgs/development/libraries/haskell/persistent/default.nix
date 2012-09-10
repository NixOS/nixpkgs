{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, liftedBase, monadControl, monadLogger
, pathPieces, poolConduit, resourcet, sqlite, text, time
, transformers, transformersBase, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "1.0.1";
  sha256 = "0k9p3icwz3mygdhmhay8lsc12qgak4ysiyfbap9a68azqrk7045p";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml blazeMarkup conduit
    liftedBase monadControl monadLogger pathPieces poolConduit
    resourcet text time transformers transformersBase
    unorderedContainers vector
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
