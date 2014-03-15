{ cabal, dataAccessor, dataAccessorTransformers, deepseq, filepath
, temporary, time, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "gnuplot";
  version = "0.5.2.1";
  sha256 = "1bzj7z803mxyxfv2123swvdv78gh5dbrf8ldc6iziry3fz5q8nb1";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    dataAccessor dataAccessorTransformers deepseq filepath temporary
    time transformers utilityHt
  ];
  jailbreak = true;
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Gnuplot";
    description = "2D and 3D plots using gnuplot";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
