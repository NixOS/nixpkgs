{ cabal, binary, mtl }:

cabal.mkDerivation (self: {
  pname = "ghc-events";
  version = "0.4.2.0";
  sha256 = "0209r9g5w4ifsaw3dkfra6kma1vyk50dc306an72mcwnp4l7dv4l";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ binary mtl ];
  testDepends = [ binary mtl ];
  meta = {
    description = "Library and tool for parsing .eventlog files from GHC";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
