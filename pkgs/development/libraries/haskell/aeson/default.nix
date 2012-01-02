{ cabal, attoparsec, blazeBuilder, deepseq, dlist, hashable, mtl
, syb, text, time, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "aeson";
  version = "0.5.0.0";
  sha256 = "1n7c0kf6rdf5p76mjcxlqrzhnfz4b1zkkbxk9w94hibb0s4kwxv6";
  buildDepends = [
    attoparsec blazeBuilder deepseq dlist hashable mtl syb text time
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/bos/aeson";
    description = "Fast JSON parsing and encoding";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
