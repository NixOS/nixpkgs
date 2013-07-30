{ cabal, ansiTerminal, async, checkers, MonadCatchIOTransformers
, QuickCheck, semigroups, transformers, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq3-haskell";
  version = "0.5";
  sha256 = "16qh3q5rshaxzl79aiivrysl3dhilnd2mw2p45ifgbgv87m277gq";
  buildDepends = [
    async MonadCatchIOTransformers semigroups transformers
  ];
  testDepends = [
    ansiTerminal checkers MonadCatchIOTransformers QuickCheck
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
