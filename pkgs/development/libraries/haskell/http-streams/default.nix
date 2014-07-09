{ cabal, aeson, aesonPretty, attoparsec, base64Bytestring
, blazeBuilder, caseInsensitive, HsOpenSSL, hspec
, hspecExpectations, httpCommon, HUnit, ioStreams
, MonadCatchIOTransformers, mtl, network, opensslStreams, snapCore
, snapServer, systemFileio, systemFilepath, text, transformers
, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "http-streams";
  version = "0.7.2.0";
  sha256 = "0h7fjnpday34skhafv2v0ybhfv0x915prfb4qa0ld4gm50scsinz";
  buildDepends = [
    aeson attoparsec base64Bytestring blazeBuilder caseInsensitive
    HsOpenSSL httpCommon ioStreams mtl network opensslStreams text
    transformers unorderedContainers
  ];
  testDepends = [
    aeson aesonPretty attoparsec base64Bytestring blazeBuilder
    caseInsensitive HsOpenSSL hspec hspecExpectations httpCommon HUnit
    ioStreams MonadCatchIOTransformers mtl network opensslStreams
    snapCore snapServer systemFileio systemFilepath text transformers
    unorderedContainers
  ];
  doCheck = false;
  meta = {
    homepage = "http://research.operationaldynamics.com/projects/http-streams/";
    description = "An HTTP client using io-streams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
