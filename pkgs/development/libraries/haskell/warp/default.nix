{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, doctest, hashable, hspec, HTTP, httpDate, httpTypes
, HUnit, liftedBase, network, networkConduit, QuickCheck
, simpleSendfile, text, time, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "2.1.3";
  sha256 = "00861dimzvbbqx3pbpihfml8k2fkvsw8kda7mkkix59xqsjwc1nz";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpDate httpTypes liftedBase network networkConduit simpleSendfile
    text transformers unixCompat void wai
  ];
  testDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit doctest
    hashable hspec HTTP httpDate httpTypes HUnit liftedBase network
    networkConduit QuickCheck simpleSendfile text time transformers
    unixCompat void wai
  ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
