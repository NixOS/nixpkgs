{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "base64-bytestring";
  version = "0.1.1.0";
  sha256 = "0vdmwajxg6w924pcsls45bz4bn29xgl3sgvdp2g1jb8f7qb58r7i";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "https://github.com/bos/base64-bytestring";
    description = "Fast base64 encoding and deconding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
