{ cabal, comonad, contravariant, semigroups, transformers }:

cabal.mkDerivation (self: {
  pname = "semigroupoids";
  version = "3.0.3";
  sha256 = "0hxg3q4bx6lmccxx9hrgb1yvnvcgb5vcaw4xv1fgdcbrydjfgfrm";
  buildDepends = [ comonad contravariant semigroups transformers ];
  meta = {
    homepage = "http://github.com/ekmett/semigroupoids";
    description = "Haskell 98 semigroupoids: Category sans id";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
