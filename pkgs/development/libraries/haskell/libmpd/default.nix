{ cabal, attoparsec, dataDefault, filepath, hspec, HUnit, mtl
, network, QuickCheck, text, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.8.0.3";
  sha256 = "0xbbk2rg6awfz5ak20956nriifga81ndk7n58lbbf5i86380akwz";
  buildDepends = [
    attoparsec dataDefault filepath mtl network text time utf8String
  ];
  testDepends = [
    dataDefault hspec HUnit mtl network QuickCheck text time utf8String
  ];
  jailbreak = true;
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell#readme";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
