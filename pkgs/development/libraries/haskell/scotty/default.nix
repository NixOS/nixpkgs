{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, httpTypes, mtl, regexCompat, text, transformers, wai, waiExtra
, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.7.1";
  sha256 = "07aj74jq0hh86ik4x5p5q65b47q44rrnd6mkp039wj9l6dmyrv3c";
  buildDepends = [
    aeson blazeBuilder caseInsensitive conduit dataDefault httpTypes
    mtl regexCompat text transformers wai waiExtra warp
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
