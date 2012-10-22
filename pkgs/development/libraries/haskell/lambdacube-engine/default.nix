{ cabal, binary, bitmap, bytestringTrie, filepath, mtl, OpenGLRaw
, stbImage, uulib, vect, vector, vectorAlgorithms, xml, zipArchive
}:

cabal.mkDerivation (self: {
  pname = "lambdacube-engine";
  version = "0.2.4";
  sha256 = "1xdp10nylndmfw16dywqrxj30g99rf9qbcx5qiglvzm1c1kxid3f";
  buildDepends = [
    binary bitmap bytestringTrie filepath mtl OpenGLRaw stbImage uulib
    vect vector vectorAlgorithms xml zipArchive
  ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/LambdaCubeEngine";
    description = "3D rendering engine written entirely in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
