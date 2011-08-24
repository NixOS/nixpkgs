{ cabal }:

cabal.mkDerivation (self: {
  pname = "base-unicode-symbols";
  version = "0.2.2.1";
  sha256 = "095x4mlkn7i9byg6kdp2f7z0x7sizmy4lgsi0rsabazyd3d8rr9l";
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
