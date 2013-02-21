{ cabal, deepseq, hashable }:

cabal.mkDerivation (self: {
  pname = "unordered-containers";
  version = "0.2.3.0";
  sha256 = "1vzgjr9jxdkmgq970ng9zi2j60awvx8iv1v6kzjlrkwzxx1a9dpd";
  buildDepends = [ deepseq hashable ];
  meta = {
    homepage = "https://github.com/tibbe/unordered-containers";
    description = "Efficient hashing-based container types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
