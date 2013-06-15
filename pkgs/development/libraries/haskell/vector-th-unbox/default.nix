{ cabal, vector }:

cabal.mkDerivation (self: {
  pname = "vector-th-unbox";
  version = "0.2.0.1";
  sha256 = "1q01yk6cyjxbdnmq31d5mfac09hbql43d7xiw1snc96nmkklfpjv";
  buildDepends = [ vector ];
  meta = {
    description = "Deriver for Data.Vector.Unboxed using Template Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
