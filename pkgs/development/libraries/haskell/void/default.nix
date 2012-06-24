{ cabal, semigroups }:

cabal.mkDerivation (self: {
  pname = "void";
  version = "0.5.6";
  sha256 = "168xp4jxrlhxdw47y3xyr3hi57xharsrll8521a1phh8vzrbpi4z";
  buildDepends = [ semigroups ];
  meta = {
    homepage = "http://github.com/ekmett/void";
    description = "A Haskell 98 logically uninhabited data type";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
