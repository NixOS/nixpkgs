{ cabal }:

cabal.mkDerivation (self: {
  pname = "snap-loader-static";
  version = "0.9.0";
  sha256 = "1blchmg0qfng7bw235z1gqkwyi764j78bc29vd5p6xxhmq111ys7";
  meta = {
    homepage = "http://snapframework.com/";
    description = "Snap: A Haskell Web Framework: static loader";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
