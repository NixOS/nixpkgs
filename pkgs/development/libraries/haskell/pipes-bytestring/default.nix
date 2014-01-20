{ cabal, pipes, pipesParse, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-bytestring";
  version = "1.0.3";
  sha256 = "11jiaf5vs0jz8m0x9dlcvflh636131bj4jnlrj3r5nz1v7a64v6b";
  buildDepends = [ pipes pipesParse transformers ];
  meta = {
    description = "ByteString support for pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
