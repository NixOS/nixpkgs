{ cabal }:

cabal.mkDerivation (self: {
  pname = "Boolean";
  version = "0.2";
  sha256 = "1r8qvsfbfjfp453pdy9ci9w584ad9bm4xv0ynx4b1yny34ag3zr3";
  meta = {
    description = "Generalized booleans and numbers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
