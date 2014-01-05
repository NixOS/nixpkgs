{ cabal, pipes, pipesParse, transformers }:

cabal.mkDerivation (self: {
  pname = "pipes-bytestring";
  version = "1.0.2";
  sha256 = "09wzmi3xh9n69xsxw0ik4qf2ld1vksca88ggknqbzbnjxq82jjrr";
  buildDepends = [ pipes pipesParse transformers ];
  meta = {
    description = "ByteString support for pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
