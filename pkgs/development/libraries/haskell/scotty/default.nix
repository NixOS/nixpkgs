{ cabal, aeson, blazeBuilder, caseInsensitive, conduit
, dataDefault, httpTypes, mtl, regexCompat, resourcet
, text, wai, waiExtra, warp
}:

cabal.mkDerivation (self: {
  pname = "scotty";
  version = "0.4.6";
  sha256 = "0g83kgqr1p03z7dks6x00id2gz95kkw00wmwp5vyz4zvx1mmmvk8";
  buildDepends = [
    aeson
    blazeBuilder
    caseInsensitive
    conduit
    dataDefault
    httpTypes
    mtl
    regexCompat
    resourcet
    text
    wai
    waiExtra
    warp
  ];
  meta = {
    homepage = "https://github.com/xich/scotty";
    description =
      "Haskell web framework inspired by Ruby's Sinatra, using WAI and Warp";
    license = self.stdenv.lib.licenses.bsd;
    platforms = self.ghc.meta.platforms;
  };
})
