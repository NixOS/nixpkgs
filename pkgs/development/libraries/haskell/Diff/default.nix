{ cabal }:

cabal.mkDerivation (self: {
  pname = "Diff";
  version = "0.2.0";
  sha256 = "15hdkrzwajnfcx8bj4jdcy4jli115g9v20msw1xyc9wnwrmbz97k";
  meta = {
    description = "O(ND) diff algorithm in haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
