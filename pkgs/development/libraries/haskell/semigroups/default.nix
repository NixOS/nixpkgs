{ cabal }:

cabal.mkDerivation (self: {
  pname = "semigroups";
  version = "0.8.4";
  sha256 = "0xphwxxzddgcw2hr4h60l3y27f1x032w049wkjs71f5hdypwapv4";
  meta = {
    homepage = "http://github.com/ekmett/semigroups/";
    description = "Haskell 98 semigroups";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
