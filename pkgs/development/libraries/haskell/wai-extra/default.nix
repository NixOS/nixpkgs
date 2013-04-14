{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, dataDefault
, dateCache, fastLogger, hspec, httpTypes, HUnit, network
, resourcet, stringsearch, text, time, transformers, void, wai
, waiLogger, waiTest, word8, zlib, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.3.4";
  sha256 = "1ay82q58pizc48rh4d8z7ybf2jjvzxqylj6mx34nvrxxlmxf5gfx";
  buildDepends = [
    ansiTerminal base64Bytestring blazeBuilder blazeBuilderConduit
    caseInsensitive conduit dataDefault dateCache fastLogger httpTypes
    network resourcet stringsearch text time transformers void wai
    waiLogger word8 zlibConduit
  ];
  testDepends = [
    blazeBuilder conduit dataDefault fastLogger hspec httpTypes HUnit
    text transformers wai waiTest zlib zlibBindings
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
