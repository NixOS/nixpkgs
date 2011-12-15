{ cabal }:

cabal.mkDerivation (self: {
  pname = "base16-bytestring";
  version = "0.1.1.3";
  sha256 = "0v08fnkykvd6y6in6f9a808vk2gfd9pf0wd7rr28z6wwxm5d2x6l";
  meta = {
    homepage = "http://github.com/bos/base16-bytestring";
    description = "Fast base16 (hex) encoding and decoding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
