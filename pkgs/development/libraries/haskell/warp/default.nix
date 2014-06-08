{ cabal, async, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, conduitExtra, doctest, hashable, hspec, HTTP, httpDate
, httpTypes, HUnit, liftedBase, network, networkConduit, QuickCheck
, simpleSendfile, streamingCommons, text, time, transformers
, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "2.1.5.2";
  sha256 = "0rv5fxw1d5dh6jzvs3bg2vjjr702xw59fx7mflygpqh8zivfh4ds";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit
    conduitExtra hashable httpDate httpTypes liftedBase network
    networkConduit simpleSendfile streamingCommons text transformers
    unixCompat void wai
  ];
  testDepends = [
    async blazeBuilder blazeBuilderConduit caseInsensitive conduit
    conduitExtra doctest hashable hspec HTTP httpDate httpTypes HUnit
    liftedBase network networkConduit QuickCheck simpleSendfile
    streamingCommons text time transformers unixCompat void wai
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
