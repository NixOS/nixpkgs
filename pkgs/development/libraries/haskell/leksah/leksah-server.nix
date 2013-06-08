{ cabal, attoparsec, attoparsecEnumerator, binary, binaryShared
, Cabal, deepseq, enumerator, filepath, haddock, hslogger, HUnit
, ltk, network, parsec, processLeksah, strict, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "leksah-server";
  version = "0.12.1.2";
  sha256 = "0fzfyq1g1jrfl40nklgvkahlcv32m4gjbcyw52dky2qzc05b0g6m";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    attoparsec attoparsecEnumerator binary binaryShared Cabal deepseq
    enumerator filepath haddock hslogger ltk network parsec
    processLeksah strict time transformers
  ];
  testDepends = [ enumerator hslogger HUnit transformers ];
  meta = {
    homepage = "http://leksah.org";
    description = "Metadata collection for leksah";
    license = "GPL";
    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
