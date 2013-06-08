{ cabal, mtl, QuickCheck, random, syb }:

cabal.mkDerivation (self: {
  pname = "ChasingBottoms";
  version = "1.3.0.6";
  sha256 = "1l40n1ylzrbp0lhm80q9djl8mf39zvmw7zzlg0gzxsqbzwbsggx8";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ mtl QuickCheck random syb ];
  meta = {
    description = "For testing partial and infinite values";
    license = self.stdenv.lib.licenses.mit;
    platforms = self.ghc.meta.platforms;
  };
})
