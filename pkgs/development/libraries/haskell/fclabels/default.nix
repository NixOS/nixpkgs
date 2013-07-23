{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.1.7.1";
  sha256 = "1f34r3bzn1cbba8d5d1j3wxrlrrj5vf09hpgd6ppina91wyj4dyn";
  buildDepends = [ mtl transformers ];
  meta = {
    homepage = "https://github.com/sebastiaanvisser/fclabels";
    description = "First class accessor labels";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
