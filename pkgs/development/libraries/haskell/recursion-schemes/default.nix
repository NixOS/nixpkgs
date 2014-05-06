{ cabal, comonad, free, transformers }:

cabal.mkDerivation (self: {
  pname = "recursion-schemes";
  version = "4.0";
  sha256 = "1xc1k04p3birxgv5h3ypw85w0cgq4d5rsmadx4pc3j409y6i5p06";
  buildDepends = [ comonad free transformers ];
  meta = {
    homepage = "http://github.com/ekmett/recursion-schemes/";
    description = "Generalized bananas, lenses and barbed wire";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
