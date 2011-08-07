{cabal, mtl} :

cabal.mkDerivation (self : {
  pname = "MonadRandom";
  version = "0.1.6";
  sha256 = "1429w2h66sf0cw992xj4w9clapcqgpdzmh80as7zxf8l87rarqqp";
  propagatedBuildInputs = [ mtl ];
  meta = {
    description = "Random-number generation monad.";
    license = "unknown";
    platforms = self.stdenv.lib.platforms.haskellPlatforms;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
