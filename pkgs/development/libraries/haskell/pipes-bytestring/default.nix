{ cabal, pipes, pipesGroup, pipesParse, profunctors, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-bytestring";
  version = "2.0.1";
  sha256 = "1vsfqqkr5danb0n30av4vk8d4by9f50y5l8ywm1xjrmwrx999gvf";
  buildDepends = [
    pipes pipesGroup pipesParse profunctors transformers
  ];
  meta = {
    description = "ByteString support for pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
