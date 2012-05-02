{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml, conduit
, liftedBase, monadControl, pathPieces, poolConduit, resourcet
, sqlite, text, time, transformers, transformersBase
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.9.0.3";
  sha256 = "07w2d5x4wlbs8smkq2mini4rkmdd38zmapwqcn59vna8cq9wslz6";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml conduit liftedBase
    monadControl pathPieces poolConduit resourcet text time
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
