{ cabal, haskellSrcExts, syb, thOrphans, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.6.0.1";
  sha256 = "181xjajvppipzgknmbhbb1i2r8rimbr5vzn6gf1ksddgw12sargd";
  buildDepends = [ haskellSrcExts syb thOrphans uniplate ];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
