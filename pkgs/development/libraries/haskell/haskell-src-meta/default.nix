{ cabal, Cabal, haskellSrcExts, syb, thLift }:

cabal.mkDerivation (self: {
  pname = "haskell-src-meta";
  version = "0.5.0.3";
  sha256 = "0c270088b5p3drr3f75ln210py2h4dfkkfgvly3ry42yl6xkvm2j";
  buildDepends = [ Cabal haskellSrcExts syb thLift ];
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
