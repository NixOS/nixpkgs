{ cabal, dataAccessor, dataAccessorTransformers, deepseq, filepath
, temporary, time, transformers, utilityHt
}:

cabal.mkDerivation (self: {
  pname = "gnuplot";
  version = "0.5.2";
  sha256 = "11gma33bikx97jra04vgnhikylw9wm1l37hdrsknl7mgk2qbrs74";
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
