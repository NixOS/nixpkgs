{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "void";
  version = "0.5.8";
  sha256 = "1iqwndpc77i4i1977z7lxj20viplr2f5pwxwa2kibyhy556bs27z";
  buildDepends = [ semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/void";
    description = "A Haskell 98 logically uninhabited data type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
