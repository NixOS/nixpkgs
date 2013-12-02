{ cabal, network, networkSimple, pipes, pipesSafe, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-network";
  version = "0.6.1";
  sha256 = "0ds6v98jamda8p72rnrwnj3x77mfx3kss57hj9ns97gga5jq88kl";
  buildDepends = [
    network networkSimple pipes pipesSafe transformers
  ];
  meta = {
    homepage = "https://github.com/k0001/pipes-network";
    description = "Use network sockets together with the pipes library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
