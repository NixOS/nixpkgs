{ cabal, pipes, pipesBytestring, pipesGroup, pipesParse, pipesSafe
, profunctors, text, textStreamDecode, transformers
}:

cabal.mkDerivation (self: {
  pname = "pipes-text";
  version = "0.0.0.10";
  sha256 = "05lrxfy6cma7g5h41c74sc22p1y38kzbmiagr3grxk5a5110vhr1";
  buildDepends = [
    pipes pipesBytestring pipesGroup pipesParse pipesSafe profunctors
    text textStreamDecode transformers
  ];
  meta = {
    homepage = "https://github.com/michaelt/text-pipes";
    description = "Text pipes";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
