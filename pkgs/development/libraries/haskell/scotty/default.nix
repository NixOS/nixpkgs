{ cabal, aeson, blazeBuilder, caseInsensitive, conduit
, conduitExtra, dataDefault, httpTypes, mtl, regexCompat, text
, transformers, wai, waiExtra, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.7.3";
  sha256 = "1cksnsaghcliwpbigs7fjb2qcxsnrqmjcjwndmf3vbfkn43w2prb";
  buildDepends = [
    aeson blazeBuilder caseInsensitive conduit conduitExtra dataDefault
    httpTypes mtl regexCompat text transformers wai waiExtra warp
  ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
