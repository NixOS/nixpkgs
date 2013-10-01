{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, httpTypes, mtl, regexCompat, resourcet, text, transformers, wai
, waiExtra, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.5.0";
  sha256 = "177c7nyjwksm2y98j2swgzfn1rmr2h0v4fk6s525kx803iibvfhc";
  buildDepends = [
    aeson blazeBuilder caseInsensitive conduit dataDefault httpTypes
    mtl regexCompat resourcet text transformers wai waiExtra warp
  ];
  meta = {
    homepage = "https://github.com/ku-fpg/scotty";
    description = "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
