{ cabal, attoparsec, dataDefault, filepath, hspec, HUnit, mtl
, network, QuickCheck, text, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.8.0.5";
  sha256 = "0jxd2xl9imfvb3dz7zqwzx392aw2cb2pl3drx5wkygbywbi5ijhh";
  buildDepends = [
    attoparsec dataDefault filepath mtl network text time utf8String
  ];
  testDepends = [
    dataDefault hspec HUnit mtl network QuickCheck text time utf8String
  ];
  jailbreak = true;
  doCheck = false;
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell#readme";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
