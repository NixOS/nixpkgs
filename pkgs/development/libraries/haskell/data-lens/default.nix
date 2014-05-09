{ cabal, comonad, semigroupoids, transformers }:

cabal.mkDerivation (self: {
  pname = "data-lens";
  version = "2.10.5";
  sha256 = "11na4wx0f0ihk87d00njwrfc430nb25dkkadv1n47yvcyfc60i90";
  buildDepends = [ comonad semigroupoids transformers ];
  meta = {
    homepage = "http://github.com/roconnor/data-lens/";
    description = "Used to be Haskell 98 Lenses";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
