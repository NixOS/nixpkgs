{ cabal, ansiTerminal, blazeBuilder, blazeBuilderConduit
, caseInsensitive, conduit, dataDefault, fastLogger, httpTypes
, network, text, time, transformers, wai, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.2.0.2";
  sha256 = "0kfbk505nli51h9lx8865gfgcnji7kgxcjfmfdanv1im00ghrq1v";
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
