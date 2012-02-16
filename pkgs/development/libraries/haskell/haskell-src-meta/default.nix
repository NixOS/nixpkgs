{ cabal, haskellSrcExts, syb, thLift, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.5.1";
  sha256 = "1wpddllq651vnsibhi0m7agc6ygj95646k29v0xl75nmfb034lz3";
  buildDepends = [ haskellSrcExts syb thLift uniplate ];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
