{ cabal, hashable, liftedBase, ReadArgs, safe, systemFilepath, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "basic-prelude";
  version = "0.3.7";
  sha256 = "1lk4f41f226v7na1cw0c8y62lm3pgwmn4560g1wmhvyxcj7185q5";
  buildDepends = [
    hashable liftedBase ReadArgs safe systemFilepath text transformers
    unorderedContainers vector
  ];
  meta = {
    homepage = "https://github.com/snoyberg/basic-prelude";
    description = "An enhanced core prelude; a common foundation for alternate preludes";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
