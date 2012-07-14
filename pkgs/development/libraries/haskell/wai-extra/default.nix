{ cabal, ansiTerminal, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, dataDefault, fastLogger, httpTypes
, network, resourcet, stringsearch, text, time, transformers, wai
, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.2.0.5";
  sha256 = "0m9zdn6cdh2j7bwsf17225rdn7jwj7iy97khbd9g7p9rv1lpdain";
  buildDepends = [
    ansiTerminal blazeBuilder blazeBuilderConduit caseInsensitive
    conduit dataDefault fastLogger httpTypes network resourcet
    stringsearch text time transformers wai zlibConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
