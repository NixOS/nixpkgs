{ cabal, binary, Cabal, epic, filepath, happy, haskeline, mtl
, parsec, transformers
}:

cabal.mkDerivation (self: {
  pname = "idris";
  version = "0.9.2";
  sha256 = "0n4dh3vxkjvw8rb5iqm8lvi21q2ljw2pzn453wfcisdadkpv4fh5";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    binary Cabal epic filepath haskeline mtl parsec transformers
  ];
  buildTools = [ happy ];
  noHaddock = true;
  meta = {
    homepage = "http://www.idris-lang.org/";
    description = "Functional Programming Language with Dependent Types";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
