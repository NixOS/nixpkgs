{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml
, blazeMarkup, conduit, liftedBase, monadControl, monadLogger
, pathPieces, poolConduit, resourcet, silently, sqlite, text, time
, transformers, transformersBase, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "1.1.3.2";
  sha256 = "1q8p5nxsf9fjhsyy1lha852f7vssp9mz6l24gg47mgv6y5mm9myv";
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
