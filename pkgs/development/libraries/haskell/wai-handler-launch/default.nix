{ cabal, blazeBuilder, blazeBuilderConduit, conduit, httpTypes
, transformers, wai, warp, zlibConduit
}:

cabal.mkDerivation (self: {
  pname = "wai-handler-launch";
  version = "2.0.0";
  sha256 = "1z03c3hjkh4k6j5dsp4973f05rk2cgl7gazac4vdq4imwfzxj3lg";
  buildDepends = [
    blazeBuilder blazeBuilderConduit conduit httpTypes transformers wai
    warp zlibConduit
  ];
  meta = {
    description = "Launch a web app in the default browser";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
