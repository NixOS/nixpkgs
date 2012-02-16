{ cabal, binary, Cabal, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-events";
  version = "0.4.0.0";
  sha256 = "0q1r5jxk8ma8rg65n4iixl5zyk4nxpzi4ywf0jz8y1nbbhbas7g2";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary Cabal mtl ];
  noHaddock = true;
  meta = {
    description = "Library and tool for parsing .eventlog files from GHC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
