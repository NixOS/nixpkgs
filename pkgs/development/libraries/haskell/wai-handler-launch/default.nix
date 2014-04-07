{ cabal, blazeBuilder, blazeBuilderConduit, conduit, conduitExtra
, httpTypes, transformers, wai, warp, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-handler-launch";
  version = "2.0.1.2";
  sha256 = "1mcjxv4dkcc5rx1bj8zc5m2q2ifcdwhsl4x4fnrv1ir9kclzsm7q";
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
