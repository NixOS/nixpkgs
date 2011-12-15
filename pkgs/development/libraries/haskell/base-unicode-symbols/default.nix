{ cabal }:

cabal.mkDerivation (self: {
  pname = "base-unicode-symbols";
  version = "0.2.2.2";
  sha256 = "13bn580r3wk7g5bq8ry04i2lvrcf576wjzlr0imli8rklkx8k3b8";
  meta = {
    homepage = "http://haskell.org/haskellwiki/Unicode-symbols";
    description = "Unicode alternatives for common functions and operators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
