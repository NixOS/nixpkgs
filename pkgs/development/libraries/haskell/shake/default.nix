{ cabal, binary, deepseq, filepath, hashable, random, time
, transformers, unorderedContainers, utf8String
}:

cabal.mkDerivation (self: {
  pname = "shake";
  version = "0.10.7";
  sha256 = "0r48kzldbgixr1c83sd7frvygqyjx32n67nri1nnamcwpvlv8hgv";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    binary deepseq filepath hashable random time transformers
    unorderedContainers utf8String
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/shake/";
    description = "Build system library, like Make, but more accurate dependencies";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
