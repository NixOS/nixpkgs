{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.1";
  sha256 = "12f4v080v8jgm02swqbbgq9yvbajmbr8ja2p6ljc7bhf3rkpwplr";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit httpTypes
    liftedBase network networkConduit simpleSendfile transformers
    unixCompat void wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
