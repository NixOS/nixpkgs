{ cabal, comonad, comonadTransformers, semigroupoids, transformers
}:

cabal.mkDerivation (self: {
  pname = "data-lens";
  version = "2.10.0";
  sha256 = "0y3rl9axakvz6kwmh08aabbz1z7y38wyrygmg4m6xby02cqbq5gk";
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
