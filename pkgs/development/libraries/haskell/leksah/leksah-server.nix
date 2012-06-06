{ cabal, attoparsec, attoparsecEnumerator, binary, binaryShared
, Cabal, deepseq, enumerator, filepath, haddock, hslogger, ltk
, network, parsec, processLeksah, strict, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "leksah-server";
  version = "0.12.1.1";
  sha256 = "063pijwj5mpczmjwwcj49dc2zgyc0l2j9j5902f1hgnvj4xg4hq6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec attoparsecEnumerator binary binaryShared Cabal deepseq
    enumerator filepath haddock hslogger ltk network parsec
    processLeksah strict time transformers
  ];
  meta = {
    homepage = "http://leksah.org";
    description = "Metadata collection for leksah";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
