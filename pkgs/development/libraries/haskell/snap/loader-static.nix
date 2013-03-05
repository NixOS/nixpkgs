{ cabal }:

cabal.mkDerivation (self: {
  pname = "snap-loader-static";
  version = "0.9.0.1";
  sha256 = "0xlb8611r9l9ld97rs27nji7k1qvjg5i62b4al38xj6i0f2skyyi";
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: static loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
