{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, httpTypes, mtl, regexCompat, text, transformers, wai, waiExtra
, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.7.0";
  sha256 = "0j08zjm8ndkpq5mrmh6rj6zc733irf7kyikw8nww754r40y6kps2";
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
