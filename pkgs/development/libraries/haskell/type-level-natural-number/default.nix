{ cabal }:

cabal.mkDerivation (self: {
  pname = "type-level-natural-number";
  version = "1.1.1";
  sha256 = "1zc26nckpcixxp1m818jhzi3dj1ysnjfc2xliq4rpmf5583k6mjw";
  meta = {
    description = "Simple, Haskell 2010-compatible type level natural numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
