{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, httpTypes, mtl, regexCompat, resourcet, text, transformers, wai
, waiExtra, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.6.0";
  sha256 = "0h5m84kp3p2bc5q9vi9b8ky7k14d7hhhqgbl1mxrqkpw3m5z95xy";
  buildDepends = [
    aeson blazeBuilder caseInsensitive conduit dataDefault httpTypes
    mtl regexCompat resourcet text transformers wai waiExtra warp
  ];
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
