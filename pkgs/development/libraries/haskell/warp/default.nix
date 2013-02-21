{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.7.4";
  sha256 = "0z043v1fjblbvkn44hzp7j8iawqzbwf67qxq7gsv7jfq1q58xbrx";
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
