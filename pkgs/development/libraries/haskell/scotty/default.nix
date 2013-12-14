{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, httpTypes, mtl, regexCompat, text, transformers, wai, waiExtra
, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.6.1";
  sha256 = "1fcrd1fxlmgkm9d6xfyb76pmn68pgk0a367lpmyh77kp0zr3f7ib";
  buildDepends = [
    aeson blazeBuilder caseInsensitive conduit dataDefault httpTypes
    mtl regexCompat text transformers wai waiExtra warp
  ];
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
