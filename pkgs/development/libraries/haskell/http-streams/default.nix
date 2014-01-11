{ cabal, attoparsec, base64Bytestring, blazeBuilder
, caseInsensitive, HsOpenSSL, hspec, hspecExpectations, HUnit
, ioStreams, MonadCatchIOTransformers, mtl, network, opensslStreams
, snapCore, snapServer, systemFileio, systemFilepath, text
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "http-streams";
  version = "0.6.0.1";
  sha256 = "1q76zl3fjh2irxaxilirjj2a58mg3c49vvm30xms0cdil9339h7d";
  buildDepends = [
    attoparsec base64Bytestring blazeBuilder caseInsensitive HsOpenSSL
    ioStreams mtl network opensslStreams text transformers
    unorderedContainers
  ];
  testDepends = [
    attoparsec base64Bytestring blazeBuilder caseInsensitive HsOpenSSL
    hspec hspecExpectations HUnit ioStreams MonadCatchIOTransformers
    mtl network opensslStreams snapCore snapServer systemFileio
    systemFilepath text transformers unorderedContainers
  ];
  meta = {
    homepage = "http://research.operationaldynamics.com/projects/http-streams/";
    description = "An HTTP client using io-streams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
  doCheck = false;
})
