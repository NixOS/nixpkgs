{ cabal, ansiTerminal, base64Bytestring, blazeBuilder
, blazeBuilderConduit, caseInsensitive, conduit, dataDefault
, fastLogger, hspec, httpTypes, HUnit, liftedBase, network
, resourcet, stringsearch, text, time, transformers, void, wai
, waiLogger, waiTest, word8, zlib, zlibBindings, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "2.0.3";
  sha256 = "18x5jcq4yl33ixl7rb79ncx107bw6y8dmw2gwcmxb93h5yiam7s5";
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
  jailbreak = true;
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
