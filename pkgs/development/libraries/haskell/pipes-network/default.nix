{ cabal, network, networkSimple, pipes, pipesSafe, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-network";
  version = "0.6.2";
  sha256 = "1y64cyi1lq7y5x3b1rv2iixlwqnz4g82nxk2m14x214fmj3np965";
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
