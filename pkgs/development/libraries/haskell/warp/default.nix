{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, doctest, hashable, hspec, HTTP, httpDate, httpTypes
, HUnit, liftedBase, network, networkConduit, QuickCheck
, simpleSendfile, time, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "2.0.3.3";
  sha256 = "02wh8jf8pcjb03xxdim9q92vr4jk9jibqqzl8kvccqlqfi5giq0f";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpDate httpTypes liftedBase network networkConduit simpleSendfile
    transformers unixCompat void wai
  ];
  testDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit doctest
    hashable hspec HTTP httpDate httpTypes HUnit liftedBase network
    networkConduit QuickCheck simpleSendfile time transformers
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
