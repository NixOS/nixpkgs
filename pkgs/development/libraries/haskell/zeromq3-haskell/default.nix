{ cabal, ansiTerminal, checkers, MonadCatchIOTransformers
, QuickCheck, transformers, zeromq
}:

cabal.mkDerivation (self: {
  pname = "zeromq3-haskell";
  version = "0.3.1";
  sha256 = "0wr157wl2qpnbfsqy4nlsnd6nbkl063387f7ab4qa07yhj5av80f";
  buildDepends = [ MonadCatchIOTransformers transformers ];
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
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
