{ cabal, haskellSrcExts, syb, thLift }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.4.0.2";
  sha256 = "1i3lhik0sa34x6rnkfa9scai9cdgx05h6mrbhwsfc7p2jlsixk92";
  buildDepends = [ haskellSrcExts syb thLift ];
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
