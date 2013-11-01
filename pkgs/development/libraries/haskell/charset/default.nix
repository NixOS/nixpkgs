{ cabal, semigroups, unorderedContainers }:

cabal.mkDerivation (self: {
  pname = "charset";
  version = "0.3.5.1";
  sha256 = "0bf9s5r2j9bkwmjxzvj5c2c7bhnf5gyh2kkx67lmy8xqalfxgmwn";
  buildDepends = [ semigroups unorderedContainers ];
  meta = {
    homepage = "http://github.com/ekmett/charset";
    description = "Fast unicode character sets based on complemented PATRICIA tries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
