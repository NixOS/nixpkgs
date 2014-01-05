{ cabal, ansiTerminal, async, checkers, MonadCatchIOTransformers
, QuickCheck, semigroups, transformers, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq3-haskell";
  version = "0.5.1";
  sha256 = "0jmdhs2apmcr3wf5r739gq9qqad59qj82h7qpdk3m4cc2a7djil0";
  buildDepends = [
    async MonadCatchIOTransformers semigroups transformers
  ];
  testDepends = [
    ansiTerminal async checkers MonadCatchIOTransformers QuickCheck
    transformers
  ];
  extraLibraries = [ zeromq ];
  doCheck = false;
  meta = {
    homepage = "http://github.com/twittner/zeromq-haskell/";
    description = "Bindings to ZeroMQ 3.x";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
