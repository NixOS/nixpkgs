{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, hspec, httpTypes, mtl, regexCompat, text, transformers, wai
, waiExtra, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.8.0";
  sha256 = "07198m8rsavdqr51abxsrmi8jail6h4ldzrr9s47il1djjba6lhh";
  buildDepends = [
    aeson blazeBuilder caseInsensitive conduit dataDefault httpTypes
    mtl regexCompat text transformers wai waiExtra warp
  ];
  testDepends = [ hspec httpTypes wai waiExtra ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
