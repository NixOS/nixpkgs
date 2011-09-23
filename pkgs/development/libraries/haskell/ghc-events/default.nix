{ cabal, binary, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-events";
  version = "0.3.0.1";
  sha256 = "08jnri6cwybg8b2f53rn8y1xzcpz32r0svahcw01g837p07mcpla";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary mtl ];
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
