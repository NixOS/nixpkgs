{ cabal, extensibleExceptions, ghcMtl, ghcPaths, haskellSrc
, MonadCatchIOMtl, mtl, random, utf8String
}:

cabal.mkDerivation (self: {
  pname = "hint";
  version = "0.3.3.3";
  sha256 = "0i7d7c2786c13npbb5np3gaidsq4kkajvm3fn2gx8djrhhlrqw5l";
  buildDepends = [
    extensibleExceptions ghcMtl ghcPaths haskellSrc MonadCatchIOMtl mtl
    random utf8String
  ];
  meta = {
    homepage = "http://darcsden.com/jcpetruzza/hint";
    description = "Runtime Haskell interpreter (GHC API wrapper)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
