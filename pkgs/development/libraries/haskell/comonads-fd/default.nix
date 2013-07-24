{ cabal, comonad, comonadTransformers, mtl, semigroups
, transformers
}:

cabal.mkDerivation (self: {
  pname = "comonads-fd";
  version = "3.0.3";
  sha256 = "06x545yq5xc3kphjipkgjrgrfvvkjpy0wji9d5fw44ca91nzglww";
  buildDepends = [
    comonad comonadTransformers mtl semigroups transformers
  ];
  meta = {
    homepage = "http://github.com/ekmett/comonads-fd/";
    description = "Comonad transformers using functional dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
