{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, hashable, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, void, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.3.5.1";
  sha256 = "1i38h2324bplkk1xh0z7cg491vl27sjd6mjs5yzb70wjz0h5ixnk";
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
