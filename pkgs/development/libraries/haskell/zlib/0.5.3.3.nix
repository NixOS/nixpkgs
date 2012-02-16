{ cabal, Cabal, zlib }:

cabal.mkDerivation (self: {
  pname = "zlib";
  version = "0.5.3.3";
  sha256 = "1hrq34w9y8m7nahvrdpnkh9rdb4jycpcpv9ix6qrxijvbz2vdbg2";
  buildDepends = [ Cabal ];
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
