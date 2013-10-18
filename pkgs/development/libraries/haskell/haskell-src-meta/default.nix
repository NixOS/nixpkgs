{ cabal, haskellSrcExts, syb, thOrphans, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.6.0.4";
  sha256 = "10dixf2abk0canwikf3wdp1ahc51400wxa7x4g59pygv8a3c1c1x";
  buildDepends = [ haskellSrcExts syb thOrphans uniplate ];
  jailbreak = true;
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
