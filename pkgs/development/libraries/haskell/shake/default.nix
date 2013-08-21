{ cabal, binary, deepseq, filepath, hashable, random, time
, transformers, unorderedContainers
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.10.6";
  sha256 = "0d2wrgraifcj0rv9jmvc5a0gl0j1jjkc4r0nmaypnv6929kl26q8";
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
