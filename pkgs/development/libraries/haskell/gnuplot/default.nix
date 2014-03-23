{ cabal, dataAccessor, dataAccessorTransformers, deepseq, filepath
, temporary, time, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "gnuplot";
  version = "0.5.2.2";
  sha256 = "0l5hi346bhs9w11i3z6yy4mcr3k50xcp3j31g6wza9grxlfqc5av";
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
