{ cabal, aeson, attoparsec, base64Bytestring, blazeHtml, conduit
, liftedBase, monadControl, mtl, pathPieces, poolConduit, sqlite
, text, time, transformers, transformersBase, unorderedContainers
, vector
}:

cabal.mkDerivation (self: {
  pname = "persistent";
  version = "0.8.0.1";
  sha256 = "1lsmsx0zxa3h83z29r6h3r94czg7c8apid9mah48f8hxlfynbqhi";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeHtml conduit liftedBase
    monadControl mtl pathPieces poolConduit text time transformers
    transformersBase unorderedContainers vector
  ];
  extraLibraries = [ sqlite ];
  meta = {
    homepage = "http://www.yesodweb.com/book/persistent";
    description = "Type-safe, multi-backend data serialization";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
