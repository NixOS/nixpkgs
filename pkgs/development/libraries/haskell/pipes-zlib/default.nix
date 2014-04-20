{ cabal, pipes, transformers, zlib, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "pipes-zlib";
  version = "0.4.0";
  sha256 = "1xi8x7cfzr7042x5jq8b6xqdhffh1jgprk90yzsfjldllck9z5ia";
  buildDepends = [ pipes transformers zlib zlibBindings ];
  meta = {
    homepage = "https://github.com/k0001/pipes-zlib";
    description = "Zlib compression and decompression for Pipes streams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
