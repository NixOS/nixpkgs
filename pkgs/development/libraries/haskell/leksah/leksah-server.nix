{ cabal, attoparsec, attoparsecConduit, binary, binaryShared, Cabal
, conduit, deepseq, executablePath, filepath, haddock, hslogger
, HUnit, ltk, network, parsec, processLeksah, strict, text, time
, transformers
}:

cabal.mkDerivation (self: {
  pname = "leksah-server";
  version = "0.13.1.0";
  sha256 = "11dggg9zaf7fhh8s6bc3dwr4b1qk7k5bj429i1vvqhrxc6968yjb";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec attoparsecConduit binary binaryShared Cabal conduit
    deepseq executablePath filepath haddock hslogger ltk network parsec
    processLeksah strict text time transformers
  ];
  testDepends = [ conduit hslogger HUnit transformers ];
  meta = {
    homepage = "http://leksah.org";
    description = "Metadata collection for leksah";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
