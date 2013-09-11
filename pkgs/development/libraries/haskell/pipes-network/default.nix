{ cabal, network, networkSimple, pipes, pipesSafe, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-network";
  version = "0.6.0";
  sha256 = "1jfj5bmpvf9vvq86jz8hbhzzjawchri90vx11fxcbz2ckks673k9";
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
