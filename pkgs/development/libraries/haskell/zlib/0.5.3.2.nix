{ cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib";
  version = "0.5.3.2";
  sha256 = "1a5xr59bw7hpgd7fwkpgkrpib7i46dsip7285pccvi2934k0628q";
  extraLibraries = [ zlib ];
  meta = {
    description = "Compression and decompression in the gzip and zlib formats";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
