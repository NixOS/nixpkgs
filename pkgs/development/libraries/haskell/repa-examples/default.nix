{ cabal, llvm, QuickCheck, random, repa, repaAlgorithms, repaIo
, vector
}:

cabal.mkDerivation (self: {
  pname = "repa-examples";
  version = "3.2.3.1";
  sha256 = "1lflgpnig2ks2mwp7bywyjqr2v426gbk1675mkkvjncgr5ahf11g";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    QuickCheck random repa repaAlgorithms repaIo vector
  ];
  extraLibraries = [ llvm ];
  jailbreak = true;
  meta = {
    homepage = "http://repa.ouroborus.net";
    description = "Examples using the Repa array library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
