{ cabal, hashable, monadControl, stm, time, transformers
, transformersBase, vector
}:

cabal.mkDerivation (self: {
  pname = "resource-pool";
  version = "0.2.2.0";
  sha256 = "0h00q6lmv21nqjs81r7y3ig4y65zpap1r6xqz9lc3zxx29bgl8xk";
  buildDepends = [
    hashable monadControl stm time transformers transformersBase vector
  ];
  meta = {
    homepage = "http://github.com/bos/pool";
    description = "A high-performance striped resource pooling implementation";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
