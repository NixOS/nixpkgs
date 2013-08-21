{ cabal, cereal, extensibleExceptions, filepath, mtl, network
, safecopy, stm
}:

cabal.mkDerivation (self: {
  pname = "acid-state";
  version = "0.11.4";
  sha256 = "1z9jswg5c2wp9k2lfp0yx7mvw6iiyizm72s552lgjn8i3slq8481";
  buildDepends = [
    cereal extensibleExceptions filepath mtl network safecopy stm
  ];
  meta = {
    homepage = "http://acid-state.seize.it/";
    description = "Add ACID guarantees to any serializable Haskell data structure";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
  };
})
