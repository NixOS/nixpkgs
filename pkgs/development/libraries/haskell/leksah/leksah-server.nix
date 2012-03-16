{ cabal, attoparsec, attoparsecEnumerator, binary, binaryShared
, Cabal, deepseq, enumerator, filepath, haddock, hslogger, ltk
, network, parsec, processLeksah, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "leksah-server";
  version = "0.12.0.5";
  sha256 = "0kr5xsnjl0brbdysw1rhd7a1gy3i0kn8rq2c5grc2m734ankil6z";
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
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
