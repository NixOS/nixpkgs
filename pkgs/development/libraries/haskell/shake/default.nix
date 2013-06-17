{ cabal, binary, deepseq, filepath, hashable, random, time
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.10.5";
  sha256 = "1abbls2rmpyxpj41c0afvfjh1bw6j6rz1n0w4jhqrmq0d32kpg7a";
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
