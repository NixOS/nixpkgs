{cabal, haskellSrcExts, syb, thLift} :

cabal.mkDerivation (self : {
  pname = "haskell-src-meta";
  version = "0.4.0.1";
  sha256 = "10g74sax8x45lphy133717y9xb43d8a684mm9qv0arjwn5v4np7s";
  propagatedBuildInputs = [ haskellSrcExts syb thLift ];
  meta = {
    description = "Parse source to template-haskell abstract syntax.";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
