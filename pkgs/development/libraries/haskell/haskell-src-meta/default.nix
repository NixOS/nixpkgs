{ cabal, haskellSrcExts, syb, thOrphans, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.6.0.3";
  sha256 = "1ag26pzppvqw9ch6jz1p0bhsld7fz0b01k7h9516hnmy215h7xai";
  buildDepends = [ haskellSrcExts syb thOrphans uniplate ];
  jailbreak = true;
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
