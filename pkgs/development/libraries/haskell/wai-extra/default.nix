{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, conduitExtra
, dataDefault, fastLogger, hspec, httpTypes, HUnit, liftedBase
, network, resourcet, stringsearch, text, time, transformers, void
, wai, waiLogger, waiTest, word8, zlib, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "2.1.1.2";
  sha256 = "000ksma1jmi7rfg2ib94baj31mcwqj2xfhkyv7lai89di0m0v6s4";
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
