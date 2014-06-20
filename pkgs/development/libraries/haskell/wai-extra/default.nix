{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, caseInsensitive, dataDefault, dataDefaultClass, deepseq
, fastLogger, hspec, httpTypes, HUnit, liftedBase, network
, resourcet, streamingCommons, stringsearch, text, time
, transformers, void, wai, waiLogger, word8, zlib
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "3.0.0.1";
  sha256 = "0i28d3pwz2fskg94xlkapdw07zkq3acnqk21kpgm5ffbj6qvbvsg";
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
