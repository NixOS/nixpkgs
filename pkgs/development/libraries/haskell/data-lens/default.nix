{ cabal, comonad, comonadTransformers, semigroupoids, transformers
}:

cabal.mkDerivation (self: {
  pname = "data-lens";
  version = "2.10.3";
  sha256 = "0x8qrcsnl1z2n3vwld0jcnapmzlzjgyzpa34qjyxpv4f15xn8vic";
  buildDepends = [
    comonad comonadTransformers semigroupoids transformers
  ];
  meta = {
    homepage = "http://github.com/roconnor/data-lens/";
    description = "Haskell 98 Lenses";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
