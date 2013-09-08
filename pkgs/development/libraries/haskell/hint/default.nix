{ cabal, extensibleExceptions, filepath, ghcMtl, ghcPaths
, haskellSrc, MonadCatchIOMtl, mtl, random, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hint";
  version = "0.3.3.7";
  sha256 = "1aba9dfkxlpmvbvllw4qnlrd300vnr0ismkn3kva1pv1cay5pifk";
  buildDepends = [
    extensibleExceptions filepath ghcMtl ghcPaths haskellSrc
    MonadCatchIOMtl mtl random utf8String
  ];
  meta = {
    homepage = "http://darcsden.com/jcpetruzza/hint";
    description = "Runtime Haskell interpreter (GHC API wrapper)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
