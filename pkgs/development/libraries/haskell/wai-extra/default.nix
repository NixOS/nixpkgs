{ cabal, blazeBuilder, blazeBuilderConduit, Cabal, caseInsensitive
, conduit, dataDefault, fastLogger, httpTypes, network, text, time
, transformers, wai, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-extra";
  version = "1.1.0";
  sha256 = "1mj2swb2bgsay9prpw6h0wmwsqyan53ndyczmhppdax4y5088f55";
  buildDepends = [
    blazeBuilder blazeBuilderConduit Cabal caseInsensitive conduit
    dataDefault fastLogger httpTypes network text time transformers wai
    zlibConduit
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "Provides some basic WAI handlers and middleware";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
