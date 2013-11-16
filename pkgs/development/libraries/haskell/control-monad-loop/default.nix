{ cabal, transformers, transformersBase }:

cabal.mkDerivation (self: {
  pname = "control-monad-loop";
  version = "0.1";
  sha256 = "003k4pp6wgn30m9ksbh8680f0klzsvd90wsl9jpqs9lpg14hi6zj";
  buildDepends = [ transformers transformersBase ];
  meta = {
    homepage = "https://github.com/joeyadams/haskell-control-monad-loop";
    description = "Simple monad transformer for imperative-style loops";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
