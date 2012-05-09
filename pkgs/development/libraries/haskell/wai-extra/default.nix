{ cabal, ansiTerminal, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, dataDefault, fastLogger, httpTypes
, network, resourcet, text, time, transformers, wai, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.2.0.4";
  sha256 = "10nd87bs6q1827ihwm13czflha2g8dhza443n55xpakba1sdgsaz";
  buildDepends = [
    ansiTerminal blazeBuilder blazeBuilderConduit caseInsensitive
    conduit dataDefault fastLogger httpTypes network resourcet text
    time transformers wai zlibConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
