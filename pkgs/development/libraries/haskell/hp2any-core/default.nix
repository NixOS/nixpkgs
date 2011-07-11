{cabal, bytestringTrie, network}:

cabal.mkDerivation (self : {
  pname = "hp2any-core";
  version = "0.10.1";
  sha256 = "1qblsvlj4x22ml3k5mlr28r5xk9rmi7lpipd369dbvdzm0rflf03";
  propagatedBuildInputs = [bytestringTrie network];
  meta = {
    description = "Heap profiling helper library";
    license = "BSD3";
    maintainers = [self.stdenv.lib.maintainers.andres];
  };
})

