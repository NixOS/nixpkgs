{ cabal, ansiTerminal, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, dataDefault, dateCache, fastLogger
, httpTypes, network, resourcet, stringsearch, text, time
, transformers, void, wai, waiLogger, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.3.2.4";
  sha256 = "12hdg5h4bk04nhcmjm5mc62dng9np0dlik4b1w1syd2lxqv6pdb9";
  buildDepends = [
    ansiTerminal blazeBuilder blazeBuilderConduit caseInsensitive
    conduit dataDefault dateCache fastLogger httpTypes network
    resourcet stringsearch text time transformers void wai waiLogger
    zlibConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
