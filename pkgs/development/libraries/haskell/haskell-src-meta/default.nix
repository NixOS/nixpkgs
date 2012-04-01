{ cabal, haskellSrcExts, syb, thLift, uniplate }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.5.1.2";
  sha256 = "09if8423dwf4jcr6p7d8j4r9i2n8jc7xxvjn1p1mwjp0ajzk8g9s";
  buildDepends = [ haskellSrcExts syb thLift uniplate ];
  meta = {
    description = "Parse source to template-haskell abstract syntax";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
