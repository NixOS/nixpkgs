{ cabal, blazeBuilder, blazeBuilderConduit, caseInsensitive
, conduit, httpTypes, liftedBase, network, networkConduit
, simpleSendfile, transformers, unixCompat, wai
}:

cabal.mkDerivation (self: {
  pname = "warp";
  version = "1.2.0.2";
  sha256 = "08gd0xzx3j47adl2pgvcc0dj7vvfj2igbvrgnl8rifz8r5gj17lq";
  buildDepends = [
    blazeBuilder blazeBuilderConduit caseInsensitive conduit httpTypes
    liftedBase network networkConduit simpleSendfile transformers
    unixCompat wai
  ];
  meta = {
    homepage = "http://github.com/yesodweb/wai";
    description = "A fast, light-weight web server for WAI applications";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
