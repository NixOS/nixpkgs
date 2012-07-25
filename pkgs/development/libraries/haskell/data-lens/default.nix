{ cabal, comonad, comonadTransformers, semigroupoids, transformers
}:

cabal.mkDerivation (self: {
  pname = "data-lens";
  version = "2.10.1";
  sha256 = "01n5lsq8nbn2lqsyz6y3md47zwpmdpfvhhlwn4fdpcl2d4hdh6xh";
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
