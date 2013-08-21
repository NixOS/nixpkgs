{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, hspec, httpAttoparsec, httpTypes, HUnit
, liftedBase, network, networkConduit, QuickCheck, simpleSendfile
, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.9.1";
  sha256 = "0s8jrgn9pxqkjvdbgvrxd0bnclkhn3hix2mff66hqpx8x4znh0zv";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpAttoparsec httpTypes liftedBase network networkConduit
    simpleSendfile transformers unixCompat void wai
  ];
  testDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    hspec httpAttoparsec httpTypes HUnit liftedBase network
    networkConduit QuickCheck simpleSendfile transformers unixCompat
    void wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
