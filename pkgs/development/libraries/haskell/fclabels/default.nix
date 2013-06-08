{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.1.6";
  sha256 = "0f5zqbqsm89lp1f7wrmcs8pn7hzbbl8id7xa6ny114bgxrfbrwpk";
  buildDepends = [ mtl transformers ];
  meta = {
    homepage = "https://github.com/sebastiaanvisser/fclabels";
    description = "First class accessor labels";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
