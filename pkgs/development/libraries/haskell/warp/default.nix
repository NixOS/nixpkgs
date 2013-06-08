{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, hspec, httpTypes, HUnit, liftedBase, network
, networkConduit, QuickCheck, simpleSendfile, transformers
, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.8.2";
  sha256 = "0s8na04n21glgkc0bcc0171ikh9cagx35s2h6i1pb5pwa8l0akv6";
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
