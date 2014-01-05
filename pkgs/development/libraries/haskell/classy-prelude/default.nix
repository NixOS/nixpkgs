{ cabal, async, basicPrelude, deepseq, hashable, hspec, liftedBase
, monadControl, monoTraversable, QuickCheck, semigroups
, systemFilepath, text, time, transformers, unorderedContainers
, vector, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.7.0";
  sha256 = "19n2kzzskrdwyacq14y8gf1avcy7clp7gzqh36dhw7pypy3x0k9n";
  buildDepends = [
    async basicPrelude deepseq hashable liftedBase monadControl
    monoTraversable semigroups systemFilepath text time transformers
    unorderedContainers vector vectorInstances
  ];
  testDepends = [
    hspec QuickCheck transformers unorderedContainers
  ];
  meta = {
    homepage = "https://github.com/snoyberg/classy-prelude";
    description = "A typeclass-based Prelude";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
