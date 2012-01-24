{ cabal, attoparsec, attoparsecEnumerator, enumerator, ghcPaths
, hlint, regexPosix, transformers
}:

cabal.mkDerivation (self: {
  pname = "ghc-mod";
  version = "1.0.7";
  sha256 = "1l490cspz4cym9cwdjr4xz7080f30sl5cm6fslb51ayy2k37zfcx";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    attoparsec attoparsecEnumerator enumerator ghcPaths hlint
    regexPosix transformers
  ];
  meta = {
    homepage = "http://www.mew.org/~kazu/proj/ghc-mod/";
    description = "Happy Haskell programming on Emacs";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
      self.stdenv.lib.maintainers.simons
    ];
  };
})
