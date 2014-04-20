{ cabal, async, exceptions, mtl, pipes, pipesConcurrency, pipesSafe
, postgresqlSimple, stm, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-postgresql-simple";
  version = "0.1.2.0";
  sha256 = "12ij2msdwjzzc93mlvvizh6amam5ld9j1a0b9xsa2awdjd21mwc1";
  buildDepends = [
    async exceptions mtl pipes pipesConcurrency pipesSafe
    postgresqlSimple stm text transformers
  ];
  meta = {
    description = "Convert various postgresql-simple calls to work with pipes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
