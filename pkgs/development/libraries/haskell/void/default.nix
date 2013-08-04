{ cabal, hashable, semigroups }:

cabal.mkDerivation (self: {
  pname = "void";
  version = "0.6.1";
  sha256 = "09pa0n17b7cz7sa699gjdmp1hxcshl3170nl5sx2x99zvxz2mv42";
  buildDepends = [ hashable semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/void";
    description = "A Haskell 98 logically uninhabited data type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
