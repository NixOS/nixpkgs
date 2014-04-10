{ cabal, aeson, blazeBuilder, caseInsensitive, conduit
, conduitExtra, dataDefault, httpTypes, mtl, regexCompat, text
, transformers, wai, waiExtra, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.7.2";
  sha256 = "1y14af3qciwycgaxzx6rjan2jgfchjzs4zbxzh8p8s1d0l4gsqlb";
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
