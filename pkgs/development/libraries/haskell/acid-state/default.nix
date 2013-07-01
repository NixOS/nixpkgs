{ cabal, cereal, extensibleExceptions, filepath, mtl, network
, safecopy, stm
}:

cabal.mkDerivation (self: {
  pname = "acid-state";
  version = "0.11.3";
  sha256 = "0808wcr2n9r3z94ljlzalzkfr7ri327vm5s8xif42n9dw600xi0j";
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
