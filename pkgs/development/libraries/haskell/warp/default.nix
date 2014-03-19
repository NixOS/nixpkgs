{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, doctest, hashable, hspec, HTTP, httpDate, httpTypes
, HUnit, liftedBase, network, networkConduit, QuickCheck
, simpleSendfile, time, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "2.1.1.2";
  sha256 = "1kiwarlfw8m04fapnihbr2n6diysi1snwvpvdya5hz555c5flda9";
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
