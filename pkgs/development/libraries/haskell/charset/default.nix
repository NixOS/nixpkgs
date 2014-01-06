{ cabal, semigroups, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "charset";
  version = "0.3.6";
  sha256 = "1g8m8nd5f100jlhvs6hbny96wy8iaggmp1lv36a5jxc54gmyxjd1";
  buildDepends = [ semigroups unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/charset";
    description = "Fast unicode character sets based on complemented PATRICIA tries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
