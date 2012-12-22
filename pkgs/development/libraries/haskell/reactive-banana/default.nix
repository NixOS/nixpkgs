{ cabal, hashable, transformers, unorderedContainers, vault }:

cabal.mkDerivation (self: {
  pname = "reactive-banana";
  version = "0.7.1.0";
  sha256 = "0diklfkc4fq05g5fhgcdkx8y0vmq26zfnmfkj95yvmwks8p9k22r";
  buildDepends = [ hashable transformers unorderedContainers vault ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Reactive-banana";
    description = "Practical library for functional reactive programming (FRP)";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.bluescreen303
    ];
  };
})
