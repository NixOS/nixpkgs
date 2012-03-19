{ cabal, haskellSrcExts, syb, thLift, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.5.1.1";
  sha256 = "1v192j47vxjisa5i2zd9lj7l9xa12jsg858yhx5qz624fcq73ggi";
  buildDepends = [ haskellSrcExts syb thLift uniplate ];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
