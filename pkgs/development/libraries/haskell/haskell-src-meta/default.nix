{ cabal, haskellSrcExts, syb, thOrphans, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.6.0.5";
  sha256 = "1cx3fkhmyhj18b4nm460xrcb1w53qw198gkqb38cjyafr2frlbyh";
  buildDepends = [ haskellSrcExts syb thOrphans uniplate ];
  jailbreak = true;
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
