{ cabal, attoparsec, dataDefault, filepath, hspec, HUnit, mtl
, network, QuickCheck, text, time, utf8String
}:

cabal.mkDerivation (self: {
  pname = "libmpd";
  version = "0.8.0.4";
  sha256 = "0dk723zly9dkwpgp4157d3a559g9j0ndxfdyp85yqcsr987wplqb";
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
