{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, liftedBase, monadControl, monadLogger
, pathPieces, poolConduit, resourcet, silently, sqlite, text, time
, transformers, transformersBase, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "1.1.2";
  sha256 = "1khzbmdw3ham8ig58srvcdsz4j5r9mg2s2ackm1f40851fa0642r";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml blazeMarkup conduit
    liftedBase monadControl monadLogger pathPieces poolConduit
    resourcet silently text time transformers transformersBase
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
