{ cabal, text }:

cabal.mkDerivation (self: {
  pname = "hflags";
  version = "0.2";
  sha256 = "1bz8w1vxqlc2c9iygr2dhy2ck1sd56zjwqzz707nqcmsqqsfmyhb";
  buildDepends = [ text ];
  meta = {
    homepage = "http://github.com/errge/hflags";
    description = "Command line flag parser, very similar to Google's gflags";
    license = "Apache-2.0";
    platforms = self.ghc.meta.platforms;
  };
})
