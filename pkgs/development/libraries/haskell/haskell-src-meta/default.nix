{ cabal, haskellSrcExts, syb, thLift }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.5";
  sha256 = "0403j2ks2as61rfl049v4h43xpgx06bm739y80vada6jc85rfinr";
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
