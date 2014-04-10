{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, conduitExtra
, dataDefault, fastLogger, hspec, httpTypes, HUnit, liftedBase
, network, resourcet, stringsearch, text, time, transformers, void
, wai, waiLogger, waiTest, word8, zlib, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "2.1.1.1";
  sha256 = "1mqpy1klr4b5dvgk89hqyd8c2vg7rl0vypy3m9hxr2r4bzifkqc1";
  buildDepends = [
    ansiTerminal base64Bytestring blazeBuilder blazeBuilderConduit
    caseInsensitive conduit conduitExtra dataDefault fastLogger
    httpTypes liftedBase network resourcet stringsearch text time
    transformers void wai waiLogger word8 zlibConduit
  ];
  testDepends = [
    blazeBuilder conduit conduitExtra dataDefault fastLogger hspec
    httpTypes HUnit resourcet text transformers wai waiTest zlib
    zlibBindings
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
