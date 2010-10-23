{cabal, Boolean, MemoTrie}:

cabal.mkDerivation (self : {
  pname = "vector-space";
  version = "0.5.9";
  sha256 = "39045384ee1f37f92fc8a84b75eb63091d083298f7be5f51f81112dd42a553b0";
  propagatedBuildInputs = [Boolean MemoTrie];
  meta = {
    description = "Vector & affine spaces, linear maps, and derivatives";
    license = "BSD";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})  

