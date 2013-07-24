{ cabal, binary, transformers }:

cabal.mkDerivation (self: {
  pname = "ghc-heap-view";
  version = "0.5.1";
  sha256 = "1qi7f3phj2j63x1wd2cvk36945cxd84s12zs03hlrn49wzx2pf1n";
  buildDepends = [ binary transformers ];
  meta = {
    description = "Extract the heap representation of Haskell values and thunks";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
