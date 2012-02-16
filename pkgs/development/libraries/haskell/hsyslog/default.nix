{ cabal, Cabal }:

cabal.mkDerivation (self: {
  pname = "hsyslog";
  version = "1.4";
  sha256 = "f3bf4bf47565cb0245afb0e8ffa3f79635b02f0032081845a5999964d828f4db";
  buildDepends = [ Cabal ];
  meta = {
    homepage = "http://gitorious.org/hsyslog";
    description = "FFI interface to syslog(3) from POSIX.1-2001.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
