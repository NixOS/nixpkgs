{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, caseInsensitive, dataDefault, dataDefaultClass, deepseq
, fastLogger, hspec, httpTypes, HUnit, liftedBase, network
, resourcet, streamingCommons, stringsearch, text, time
, transformers, void, wai, waiLogger, word8, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "3.0.0";
  sha256 = "0spjyimqfj7hx8zgmal4laqy8p1inj8hl2402b5s6zqdn36lldfs";
  buildDepends = [
    ansiTerminal base64Bytestring blazeBuilder caseInsensitive
    dataDefaultClass deepseq fastLogger httpTypes liftedBase network
    resourcet streamingCommons stringsearch text time transformers void
    wai waiLogger word8
  ];
  testDepends = [
    blazeBuilder dataDefault fastLogger hspec httpTypes HUnit resourcet
    text transformers wai zlib
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
