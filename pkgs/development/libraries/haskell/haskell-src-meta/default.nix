{ cabal, haskellSrcExts, syb, thOrphans, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.6.0.2";
  sha256 = "1msqnsavghsc5bil3mm9swpi9a54pki4162jdfwwvlzvdmfvk9hp";
  buildDepends = [ haskellSrcExts syb thOrphans uniplate ];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
