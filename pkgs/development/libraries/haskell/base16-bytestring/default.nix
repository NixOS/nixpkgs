{ cabal }:

cabal.mkDerivation (self: {
  pname = "base16-bytestring";
  version = "0.1.1.5";
  sha256 = "1fgd3zdzjfry6jaz8hwhim0p2c35l73cxxambh0ff7p5fqjrlwym";
  meta = {
    homepage = "http://github.com/bos/base16-bytestring";
    description = "Fast base16 (hex) encoding and decoding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
