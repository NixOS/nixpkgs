{ cabal, ansiTerminal, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, dataDefault, fastLogger, httpTypes
, network, text, time, transformers, wai, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.1.0.1";
  sha256 = "0kavvbywkkwj9914y622wsziwfca9qjaqz798mjhl1ip5bfy73b0";
  buildDepends = [
    ansiTerminal blazeBuilder blazeBuilderConduit caseInsensitive
    conduit dataDefault fastLogger httpTypes network text time
    transformers wai zlibConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
