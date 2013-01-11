{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.7";
  sha256 = "06648wqiwlcsvd41qdqdbgn1zcq890iq39zsxi24vf4s8q7jnzyf";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpTypes liftedBase network networkConduit simpleSendfile
    transformers unixCompat void wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
