{ cabal, pipes, pipesBytestring, pipesGroup, pipesParse, pipesSafe
, profunctors, streamingCommons, text, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-text";
  version = "0.0.0.11";
  sha256 = "0c56gxm17bapdjgbp2f55z3f6vq8ryvsljqp3bcjjj18xv5pf1ls";
  buildDepends = [
    pipes pipesBytestring pipesGroup pipesParse pipesSafe profunctors
    streamingCommons text transformers
  ];
  meta = {
    homepage = "https://github.com/michaelt/text-pipes";
    description = "Text pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
