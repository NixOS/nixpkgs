{ cabal, bytestringTrie, network, time }:

cabal.mkDerivation (self: {
  pname = "hp2any-core";
  version = "0.10.1";
  sha256 = "1qblsvlj4x22ml3k5mlr28r5xk9rmi7lpipd369dbvdzm0rflf03";
  buildDepends = [ bytestringTrie network time ];
  meta = {
    homepage = "http://www.haskell.org/haskellwiki/Hp2any";
    description = "Heap profiling helper library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
