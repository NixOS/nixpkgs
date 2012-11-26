{ cabal, aeson, attoparsec, curl, mtl, pureMD5, urlencoded
, utf8String, xml
}:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.0.3.8";
  sha256 = "0icx86x3w85z0pqdxcch583j6jk5id5aw9gf24266mgfg5k6iwdy";
  buildDepends = [
    aeson attoparsec curl mtl pureMD5 urlencoded utf8String xml
  ];
  meta = {
    description = "Wrapper to Lastfm API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
