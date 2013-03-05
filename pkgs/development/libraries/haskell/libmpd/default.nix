{ cabal, dataDefault, filepath, hspec, HUnit, mtl, network
, QuickCheck, text, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.8.0.2";
  sha256 = "1phlbb5lsapw2hb0db7906ddlmvnpyk1xbgxvl9zp9zfd0sn40aj";
  buildDepends = [ filepath mtl network text time utf8String ];
  testDepends = [
    dataDefault hspec HUnit mtl network QuickCheck text time utf8String
  ];
  meta = {
    homepage = "http://github.com/joachifm/libmpd-haskell";
    description = "An MPD client library";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
