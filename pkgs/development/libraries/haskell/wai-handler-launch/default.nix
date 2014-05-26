{ cabal, blazeBuilder, blazeBuilderConduit, conduit, conduitExtra
, httpTypes, transformers, wai, warp, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-handler-launch";
  version = "2.0.1.3";
  sha256 = "06im28x26jbzbdk9xz33kqvzblglk3b3b60qwal836hima69alsd";
  buildDepends = [
    blazeBuilder blazeBuilderConduit conduit conduitExtra httpTypes
    transformers wai warp zlibConduit
  ];
  meta = {
    description = "Launch a web app in the default browser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
