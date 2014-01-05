{ cabal }:

cabal.mkDerivation (self: {
  pname = "hsyslog";
  version = "1.6";
  sha256 = "1vw0yhp4s7wiq18rfg1jgm3ccqaim7w8ry0cdqijzbdnz65hibvp";
  meta = {
    homepage = "http://github.com/peti/hsyslog";
    description = "FFI interface to syslog(3) from POSIX.1-2001";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
