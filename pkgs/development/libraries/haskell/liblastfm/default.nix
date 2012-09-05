{ cabal, aeson, curl, mtl, pureMD5, urlencoded, utf8String, xml }:

cabal.mkDerivation (self: {
  pname = "liblastfm";
  version = "0.0.3.4";
  sha256 = "1d8fypl9s64jpsr8hygyfqq6jzv1bvd22zq4f93xsffpvv7nqnyk";
  buildDepends = [
    aeson curl mtl pureMD5 urlencoded utf8String xml
  ];
  meta = {
    description = "Wrapper to Lastfm API";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
