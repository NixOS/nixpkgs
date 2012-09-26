{ cabal, deepseq, hashable }:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.2.1";
  sha256 = "0ny8w7xw0ch3yp0fnskzygz61b72ln5s5ccsdlcqpp29cvfar6zy";
  buildDepends = [ deepseq hashable ];
  meta = {
    homepage = "https://github.com/tibbe/unordered-containers";
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
