{cabal} :

cabal.mkDerivation (self : {
  pname = "base-unicode-symbols";
  version = "0.2.2";
  sha256 = "06m31fzy387ylk9yw4lbba8fwzql1d2q774251870z8xgqfc52gk";
  meta = {
    homepage = "http://haskell.org/haskellwiki/Unicode-symbols";
    description = "Unicode alternatives for common functions and operators";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.simons
      self.stdenv.lib.maintainers.andres
    ];
  };
})
