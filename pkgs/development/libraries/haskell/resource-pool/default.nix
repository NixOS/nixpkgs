{ cabal, hashable, monadControl, stm, time, transformers
, transformersBase, vector
}:

cabal.mkDerivation (self: {
  pname = "resource-pool";
  version = "0.2.1.1";
  sha256 = "1ypyzy7mkmpab6rghsizrx6raam3l2acwxm56x7jmcv8s2algi1g";
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
