{ cabal, Cabal, filepath, haskellSrcExts, syb, transformers
, uniplate
}:

cabal.mkDerivation (self: {
  pname = "derive";
  version = "2.5.5";
  sha256 = "1vv7y2jfyxq2abh4avyjwia309a6rylbyiqia1m0ka7zwv2rxd6y";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [
    Cabal filepath haskellSrcExts syb transformers uniplate
  ];
  meta = {
    homepage = "http://community.haskell.org/~ndm/derive/";
    description = "A program and library to derive instances for data types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
