{ cabal, hashable, liftedBase, ReadArgs, systemFilepath, text
, transformers, unorderedContainers, vector
}:

cabal.mkDerivation (self: {
  pname = "basic-prelude";
  version = "0.3.2.0";
  sha256 = "1sdwkh9xrsx8v96d06jll7cqc0p6ykv2y9gnjzpbfx0k3ns69kcj";
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
