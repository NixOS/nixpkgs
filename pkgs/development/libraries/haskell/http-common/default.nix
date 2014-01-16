{ cabal, base64Bytestring, blazeBuilder, caseInsensitive, mtl
, network, text, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "http-common";
  version = "0.7.0.1";
  sha256 = "1brflygyf8y60jilrl6p8jdr5k5zwcqpdhj6j51vj9n4gsnr6a8d";
  buildDepends = [
    base64Bytestring blazeBuilder caseInsensitive mtl network text
    transformers unorderedContainers
  ];
  meta = {
    homepage = "http://research.operationaldynamics.com/projects/http-streams/";
    description = "Common types for HTTP clients and servers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
