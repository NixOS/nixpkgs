{ cabal, attoparsec, attoparsecEnumerator, binary, binaryShared
, Cabal, deepseq, enumerator, filepath, haddock, hslogger, ltk
, network, parsec, processLeksah, time, transformers
}:

cabal.mkDerivation (self: {
  pname = "leksah-server";
  version = "0.12.0.4";
  sha256 = "0lv6z2b79cxvcz5mldyicx87lp3a0xfmv0wjd0cjf954cdizccg2";
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
