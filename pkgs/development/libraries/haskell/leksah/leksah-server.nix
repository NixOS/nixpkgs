{ cabal, attoparsec, attoparsecEnumerator, binary, binaryShared
, Cabal, deepseq, enumerator, filepath, haddock, hslogger, ltk
, network, parsec, processLeksah, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "leksah-server";
  version = "0.12.1.0";
  sha256 = "1jqrlz08ivr521a64cbdkixhgjra69qlfrasch7yac63dvf160i4";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec attoparsecEnumerator binary binaryShared Cabal deepseq
    enumerator filepath haddock hslogger ltk network parsec
    processLeksah time transformers
  ];
  meta = {
    homepage = "http://leksah.org";
    description = "Metadata collection for leksah";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
