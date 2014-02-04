{ cabal, pipes, pipesGroup, pipesParse, profunctors, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-bytestring";
  version = "2.0.0";
  sha256 = "17l74g7xfl1i32jj9qa9ivbb3ndi68hkc1b6jchwnn19rmg51j9i";
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
