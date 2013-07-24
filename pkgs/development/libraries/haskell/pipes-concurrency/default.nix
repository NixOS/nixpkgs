{ cabal, pipes, stm }:

cabal.mkDerivation (self: {
  pname = "pipes-concurrency";
  version = "1.2.1";
  sha256 = "036cn6pafqpf2811iigablks3zk747bnzji9ykrgwhpja427vlbl";
  buildDepends = [ pipes stm ];
  meta = {
    description = "Concurrency for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
