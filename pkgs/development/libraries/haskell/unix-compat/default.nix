{ cabal }:

cabal.mkDerivation (self: {
  pname = "unix-compat";
  version = "0.3.0.2";
  sha256 = "0rikix2l8d0n948pzri2rdis9k5q0m73h7vxsxjz1vh24ryjj59f";
  meta = {
    homepage = "http://github.com/jystic/unix-compat";
    description = "Portable POSIX-compatibility layer";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
