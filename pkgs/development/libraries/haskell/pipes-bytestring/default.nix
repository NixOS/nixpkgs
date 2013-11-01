{ cabal, pipes, pipesParse, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-bytestring";
  version = "1.0.1";
  sha256 = "0zk2n9mly1mjh1zb3z33gab362abgh8c0mw88mmwnlfszq97hcz7";
  buildDepends = [ pipes pipesParse transformers ];
  meta = {
    description = "ByteString support for pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
