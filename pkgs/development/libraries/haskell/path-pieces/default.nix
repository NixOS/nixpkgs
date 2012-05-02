{ cabal, text, time }:

cabal.mkDerivation (self: {
  pname = "path-pieces";
  version = "0.1.1";
  sha256 = "17ymk2azgz2c1hwnzqd9xy77hh51mvrgz4zs7lz4ik6rnvvihraz";
  buildDepends = [ text time ];
  meta = {
    homepage = "http://github.com/snoyberg/path-pieces";
    description = "Components of paths";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
