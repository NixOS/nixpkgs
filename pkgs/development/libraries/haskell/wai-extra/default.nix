{ cabal, ansiTerminal, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, dataDefault, dateCache, fastLogger
, hspec, httpTypes, HUnit, network, resourcet, stringsearch, text
, time, transformers, void, wai, waiLogger, waiTest, zlib
, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.3.3.1";
  sha256 = "0ss58s5m8yp326q0651znifbfl6kpimyhm479wx8r3zx3ndl47q9";
  buildDepends = [
    ansiTerminal blazeBuilder blazeBuilderConduit caseInsensitive
    conduit dataDefault dateCache fastLogger httpTypes network
    resourcet stringsearch text time transformers void wai waiLogger
    zlibConduit
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
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
