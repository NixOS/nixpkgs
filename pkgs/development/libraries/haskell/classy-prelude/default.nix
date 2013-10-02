{ cabal, async, basicPrelude, deepseq, hashable, hspec, liftedBase
, monadControl, monoTraversable, QuickCheck, semigroups
, systemFilepath, text, transformers, unorderedContainers, vector
, vectorInstances
}:

cabal.mkDerivation (self: {
  pname = "classy-prelude";
  version = "0.6.0";
  sha256 = "0wpymr2gl0hmbgpw0qd0h1ik1h42s8raykq7jsdjqnmcvsmww5j6";
  buildDepends = [
    async basicPrelude deepseq hashable liftedBase monadControl
    monoTraversable semigroups systemFilepath text transformers
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
