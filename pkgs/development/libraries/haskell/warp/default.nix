{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, hspec, httpTypes, HUnit, liftedBase, network
, networkConduit, QuickCheck, simpleSendfile, transformers
, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.7.5";
  sha256 = "1y6xnlrqfd763s5r79f53vlbk4iirnci6wpaicrm14f791w2mppc";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    httpTypes liftedBase network networkConduit simpleSendfile
    transformers unixCompat void wai
  ];
  testDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit hashable
    hspec httpTypes HUnit liftedBase network networkConduit QuickCheck
    simpleSendfile transformers unixCompat void wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
