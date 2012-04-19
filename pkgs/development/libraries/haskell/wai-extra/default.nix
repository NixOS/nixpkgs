{ cabal, ansiTerminal, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, dataDefault, fastLogger, httpTypes
, network, text, time, transformers, wai, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.2.0.3";
  sha256 = "0iigswknh5w5zi6r99jks3bppylnw9hca9by2klwr2biw07nf09d";
  buildDepends = [
    ansiTerminal blazeBuilder blazeBuilderConduit caseInsensitive
    conduit dataDefault fastLogger httpTypes network text time
    transformers wai zlibConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
