{ cabal, binary, deepseq, filepath, hashable, random, time
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.10.1";
  sha256 = "0k8hk5aw5xk4aq7g8yjlkn1rjhcdy3jd5mna9phjs23kmfsmayk6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath hashable random time transformers
    unorderedContainers
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/shake/";
    description = "Build system library, like Make, but more accurate dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
