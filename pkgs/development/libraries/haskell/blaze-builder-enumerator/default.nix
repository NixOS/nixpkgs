{ cabal, blazeBuilder, enumerator, transformers }:

cabal.mkDerivation (self: {
  pname = "blaze-builder-enumerator";
  version = "0.2.0.5";
  sha256 = "0bbbv9wwzw9ss3d02mszdzxzhg6pcrnpwir9bvby7xkmfqpyffaa";
  buildDepends = [ blazeBuilder enumerator transformers ];
  meta = {
    homepage = "https://github.com/meiersi/blaze-builder-enumerator";
    description = "Enumeratees for the incremental conversion of builders to bytestrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
