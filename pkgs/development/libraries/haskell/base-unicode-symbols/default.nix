{ cabal }:

cabal.mkDerivation (self: {
  pname = "base-unicode-symbols";
  version = "0.2.2.3";
  sha256 = "0803ncdydkxivn4kcjfn9v0lm43xg47y5iws7lajhhyg6v4zq08j";
  meta = {
    homepage = "http://haskell.org/haskellwiki/Unicode-symbols";
    description = "Unicode alternatives for common functions and operators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
