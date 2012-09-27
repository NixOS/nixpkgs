{ cabal, binary }:

cabal.mkDerivation (self: {
  pname = "rank1dynamic";
  version = "0.1.0.0";
  sha256 = "19wyklhf5sghip0i71sza7lv50lj2dawfxy6k67njxr1y56ky92w";
  buildDepends = [ binary ];
  meta = {
    homepage = "http://github.com/haskell-distributed/distributed-process";
    description = "Like Data.Dynamic/Data.Typeable but with support for rank-1 polymorphic types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
