{ cabal, pipes, stm }:

cabal.mkDerivation (self: {
  pname = "pipes-concurrency";
  version = "1.2.0";
  sha256 = "058v9d3wf9n1d25rhdq5vj60p8mll5yv2zn2k1092bg7qisip1fq";
  buildDepends = [ pipes stm ];
  meta = {
    description = "Concurrency for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
