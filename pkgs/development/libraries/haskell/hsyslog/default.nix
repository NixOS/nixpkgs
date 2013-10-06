{ cabal }:

cabal.mkDerivation (self: {
  pname = "hsyslog";
  version = "1.5";
  sha256 = "1dpcawnl3a5lw2w8gc9920sjrw43qmq1k2zws8rx2q0r6ps7nhgp";
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
