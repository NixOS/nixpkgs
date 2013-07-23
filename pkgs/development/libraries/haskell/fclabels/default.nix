{ cabal, mtl, transformers }:

cabal.mkDerivation (self: {
  pname = "fclabels";
  version = "1.1.7";
  sha256 = "0mk75fk3c4ilb2hmz972ymv1pkzxp6010mlma7hw1l13dfy0hy9v";
  buildDepends = [ mtl transformers ];
  noHaddock = true;
  meta = {
    homepage = "https://github.com/sebastiaanvisser/fclabels";
    description = "First class accessor labels";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
