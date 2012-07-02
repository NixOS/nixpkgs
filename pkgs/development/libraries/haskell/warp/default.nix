{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.2.2";
  sha256 = "0jja9fjjd0f54awbx2p865w1mxj75qxy17skj1sc83i5ck32n6f0";
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
