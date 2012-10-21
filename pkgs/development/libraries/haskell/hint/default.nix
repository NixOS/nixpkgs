{ cabal, extensibleExceptions, filepath, ghcMtl, ghcPaths
, haskellSrc, MonadCatchIOMtl, mtl, random, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hint";
  version = "0.3.3.5";
  sha256 = "09pd4b105c2ikf4ap96fz8091qra7hypq3k3ik0kay3bb532hmlq";
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
