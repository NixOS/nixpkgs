{ cabal, binary, deepseq, filepath, hashable, random, time
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.9.1";
  sha256 = "19jpnf7794ii1v0rfafmcrs71flwz6hmz72ng529ll12iy64xwkv";
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
