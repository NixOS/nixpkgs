{ cabal, hashable, liftedBase, ReadArgs, systemFilepath, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "basic-prelude";
  version = "0.3.4.0";
  sha256 = "0layc06df7df4mf4zafj87c4klsvkxbhi69dkv4ag9fkzvs62sz6";
  buildDepends = [
    hashable liftedBase ReadArgs systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/basic-prelude";
    description = "An enhanced core prelude; a common foundation for alternate preludes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
