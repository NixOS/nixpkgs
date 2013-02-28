{ cabal, hashable, liftedBase, ReadArgs, systemFilepath, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "basic-prelude";
  version = "0.3.3.0";
  sha256 = "1b3fydswi7sj2j5d3jfynd9r5qg8pzlv1qdb9xp56ig01ig18cyv";
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
