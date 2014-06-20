{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, hspec, httpTypes, liftedBase, monadControl, mtl, regexCompat
, text, transformers, transformersBase, wai, waiExtra, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.8.1";
  sha256 = "182iwsz5h7p08sqwfzb332gwj1wjx7fhhazm6gfdc0incab769m0";
  buildDepends = [
    aeson blazeBuilder caseInsensitive conduit dataDefault httpTypes
    monadControl mtl regexCompat text transformers transformersBase wai
    waiExtra warp
  ];
  testDepends = [ hspec httpTypes liftedBase wai waiExtra ];
  jailbreak = true;
  meta = {
    homepage = "https://github.com/scotty-web/scotty";
    description = "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
