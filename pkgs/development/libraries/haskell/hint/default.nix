{ cabal, extensibleExceptions, filepath, ghcMtl, ghcPaths
, haskellSrc, MonadCatchIOMtl, mtl, random, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hint";
  version = "0.3.3.6";
  sha256 = "080wnds99lg9p4n2h9d4bpgvk73yzc3im2ysn1r8f3nqai4b2can";
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
