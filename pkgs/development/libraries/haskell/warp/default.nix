{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.0.1";
  sha256 = "0bgmz2kd2z9agpid0w2whfz1cyrmiaiyap20za1l56d88m0p1z45";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit httpTypes
    liftedBase network networkConduit simpleSendfile transformers
    unixCompat wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
