{ cabal, semigroups, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "charset";
  version = "0.3.7";
  sha256 = "1x912dx5650x8ql3ivhpiwmxd6kv7zghark3s8ljvl1g3qr1pxd6";
  buildDepends = [ semigroups unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/charset";
    description = "Fast unicode character sets based on complemented PATRICIA tries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
