{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, dataDefault
, fastLogger, hspec, httpTypes, HUnit, liftedBase, network
, resourcet, stringsearch, text, time, transformers, void, wai
, waiLogger, waiTest, word8, zlib, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "2.0.1.1";
  sha256 = "1jnq7flvp5870cn0xvdjqvzzls2ffyc82sj757jc6kxps107lllm";
  buildDepends = [
    ansiTerminal base64Bytestring blazeBuilder blazeBuilderConduit
    caseInsensitive conduit dataDefault fastLogger httpTypes liftedBase
    network resourcet stringsearch text time transformers void wai
    waiLogger word8 zlibConduit
  ];
  testDepends = [
    blazeBuilder conduit dataDefault fastLogger hspec httpTypes HUnit
    resourcet text transformers wai waiTest zlib zlibBindings
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
