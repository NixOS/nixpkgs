{ cabal }:

cabal.mkDerivation (self: {
  pname = "base16-bytestring";
  version = "0.1.1.2";
  sha256 = "1isxyl52vh0lg195wq9nkr3hlmbw3d3c9aymxlz8hynz0hh1q1z0";
  meta = {
    homepage = "http://github.com/mailrank/base16-bytestring";
    description = "Fast base16 (hex) encoding and deconding for ByteStrings";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
