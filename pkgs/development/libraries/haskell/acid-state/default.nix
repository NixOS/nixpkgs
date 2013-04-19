{ cabal, cereal, safecopy, stm, extensibleExceptions, mtl, network
}:

cabal.mkDerivation (self: {
  pname = "acid-state";
  version = "0.8.3";
  sha256 = "1n7vafw3jz7kmlp5jqn1wv0ip2rcbyfx0cdi2m1a2lvpi6dh97gc";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    cereal safecopy stm extensibleExceptions mtl network
  ];
  meta = {
    homepage = "http://acid-state.seize.it/";
    description = "Add ACID guarantees to any serializable Haskell data structure.";
    license = self.stdenv.lib.licenses.publicDomain;
    platforms = self.ghc.meta.platforms;
    maintainers = [
    ];
  };
})
