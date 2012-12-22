{ cabal, hashable, ReadArgs, systemFilepath, text, transformers
, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "basic-prelude";
  version = "0.3.1.0";
  sha256 = "15k89z78zjhga36wrvfn8b17hsmlwr1na6xq0gmimivfrdlnz5j0";
  buildDepends = [
    hashable ReadArgs systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/basic-prelude";
    description = "An enhanced core prelude; a common foundation for alternate preludes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
