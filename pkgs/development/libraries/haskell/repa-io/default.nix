{ cabal, binary, bmp, repa, vector }:

cabal.mkDerivation (self: {
  pname = "repa-io";
  version = "3.2.2.1";
  sha256 = "0wcg4a8z6qf7jg353b89ci4pzqvb7pnzgb6ml3av6l54n9rg4vsp";
  buildDepends = [ binary bmp repa vector ];
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Read and write Repa arrays in various formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
