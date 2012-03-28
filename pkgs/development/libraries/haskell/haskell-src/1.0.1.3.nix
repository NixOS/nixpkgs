{ cabal, happy }:

cabal.mkDerivation (self: {
  pname = "haskell-src";
  version = "1.0.1.3";
  sha256 = "a7872900acd2293775a6bdc6dc8f70438ccd80e62d2d1e2394ddff15b1883e89";
  buildTools = [ happy ];
  meta = {
    description = "Manipulating Haskell source code";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
