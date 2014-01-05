{ cabal, async, exceptions, mtl, pipes, pipesConcurrency, pipesSafe
, postgresqlSimple, stm, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-postgresql-simple";
  version = "0.1.1.2";
  sha256 = "0m9p3ddrv73c24yh0a2q14zkr4iibfysy2q9bwp6m100z3qk1bgy";
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
