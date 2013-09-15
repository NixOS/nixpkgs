{ cabal, pipes, transformers, zlib, zlibBindings }:

cabal.mkDerivation (self: {
  pname = "pipes-zlib";
  version = "0.3.0";
  sha256 = "15d475rxziazxlbcbm8snik45z88kk7gxbxrpv4070bwylh3z0wc";
  buildDepends = [ pipes transformers zlib zlibBindings ];
  meta = {
    homepage = "https://github.com/k0001/pipes-zlib";
    description = "Zlib compression and decompression for Pipes streams";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.ocharles ];
  };
})
