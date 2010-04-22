{cabal}:

cabal.mkDerivation (self : {
  pname = "unix-compat";
  version = "0.1.2.1";
  sha256 = "553326e140f71f09cedeec5f74666171c2ad2b3d9ba4312da97da02cbf8a2e85";
  meta = {
    description = "Portable POSIX-compatibility layer";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

