{ cabal, Cabal, mtl, split, syb, transformers }:

cabal.mkDerivation (self: {
  pname = "cmdlib";
  version = "0.3.5";
  sha256 = "0218f4rl64wvvka95m969hg5y9vc29dqaawfcnk7d1qsv3hx9ydl";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal mtl split syb transformers ];
  meta = {
    description = "a library for command line parsing & online help";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
