{ cabal, aeson, blazeBuilder, caseInsensitive, conduit, dataDefault
, httpTypes, mtl, regexCompat, text, transformers, wai, waiExtra
, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.6.2";
  sha256 = "0szki6wcmhj20kxhmgidgf930xwhiq03qrk8m0x8aklcjzkhvy69";
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
