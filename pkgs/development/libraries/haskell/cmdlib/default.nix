{ cabal, mtl, split, syb }:

cabal.mkDerivation (self: {
  pname = "cmdlib";
  version = "0.3.3";
  sha256 = "0gryz70d69r9pscwxmn5yr02r0zvvgj1vwc3g9klgbkipbsa7xvk";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl split syb ];
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
