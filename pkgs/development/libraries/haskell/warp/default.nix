{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, hspec, HTTP, httpAttoparsec, httpTypes, HUnit
, liftedBase, network, networkConduit, QuickCheck, simpleSendfile
, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.10.1";
  sha256 = "1pi2x0gi4r6qy151a9gmfq223yiy53j7prj2pyn00cprr0m4mk2v";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpAttoparsec httpTypes liftedBase network networkConduit
    simpleSendfile transformers unixCompat void wai
  ];
  testDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    hspec HTTP httpAttoparsec httpTypes HUnit liftedBase network
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
