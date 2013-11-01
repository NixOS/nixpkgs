{ cabal, free, pipes, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-parse";
  version = "2.0.1";
  sha256 = "04sqjdmgkgk5qva0gyrblhdvmljgmci2yzzw7y17pmnwxwdja4f0";
  buildDepends = [ free pipes transformers ];
  meta = {
    description = "Parsing infrastructure for the pipes ecosystem";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
