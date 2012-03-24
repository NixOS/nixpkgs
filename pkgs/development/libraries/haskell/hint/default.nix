{ cabal, extensibleExceptions, filepath, ghcMtl, ghcPaths
, haskellSrc, MonadCatchIOMtl, mtl, random, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hint";
  version = "0.3.3.4";
  sha256 = "0pmvhlj9m0s1wvw8ppx1wx879lwzg38bcvhy1ma1d4wnrpq3bhiy";
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
