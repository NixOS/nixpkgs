{ cabal, pipes, pipesGroup, pipesParse, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-bytestring";
  version = "2.1.0";
  sha256 = "1q98444kpcdc817zbg121g2n1mhblrdfsmd0bs5rqq6ijxb213z0";
  buildDepends = [ pipes pipesGroup pipesParse transformers ];
  meta = {
    description = "ByteString support for pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
