{ cabal, mtl, QuickCheck, random, syb }:

cabal.mkDerivation (self: {
  pname = "ChasingBottoms";
  version = "1.3.0.5";
  sha256 = "0g3c52c8gpm0xlnxxdgazz0f7zpnjvdx5vffsv1zr3vcn3kp1xy0";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl QuickCheck random syb ];
  meta = {
    description = "For testing partial and infinite values";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
  };
})
