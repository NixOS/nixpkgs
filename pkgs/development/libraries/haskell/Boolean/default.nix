{ cabal }:

cabal.mkDerivation (self: {
  pname = "Boolean";
  version = "0.1.2";
  sha256 = "07mhg9zf98hlm7qq9gdbrq68a8rpvdby1jwmgrvf3nv2k47dimx6";
  meta = {
    description = "Generalized booleans";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
