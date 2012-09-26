{ cabal, aeson, curl, mtl, pureMD5, urlencoded, utf8String, xml }:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.0.3.6";
  sha256 = "0xmrciv489dvksgpg9g83kna34x1amsx45wvpngcpnx4m44fcp4w";
  buildDepends = [
    aeson curl mtl pureMD5 urlencoded utf8String xml
  ];
  meta = {
    description = "Wrapper to Lastfm API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
