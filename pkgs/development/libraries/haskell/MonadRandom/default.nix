{ cabal, Cabal, mtl, random }:

cabal.mkDerivation (self: {
  pname = "MonadRandom";
  version = "0.1.6";
  sha256 = "1429w2h66sf0cw992xj4w9clapcqgpdzmh80as7zxf8l87rarqqp";
  buildDepends = [ Cabal mtl random ];
  meta = {
    description = "Random-number generation monad";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
