{ cabal, aeson, curl, mtl, pureMD5, urlencoded, utf8String, xml }:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.0.3.5";
  sha256 = "185vk5648m2xf74fmv7ccrbzvqd5qmlfa9fnn0ywv3ikmf61y0fg";
  buildDepends = [
    aeson curl mtl pureMD5 urlencoded utf8String xml
  ];
  meta = {
    description = "Wrapper to Lastfm API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
