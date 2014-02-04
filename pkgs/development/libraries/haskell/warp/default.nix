{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, doctest, hashable, hspec, HTTP, httpDate, httpTypes
, HUnit, liftedBase, network, networkConduit, QuickCheck
, simpleSendfile, time, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "2.0.2.1";
  sha256 = "0r8kpg2k7mr9y7nlccvfk6qbzgv459gidbaw6sgaxb26f6bgipgk";
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
