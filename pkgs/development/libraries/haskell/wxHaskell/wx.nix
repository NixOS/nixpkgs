{ cabal, stm, wxcore }:

cabal.mkDerivation (self: {
  pname = "wx";
  version = "0.90";
  sha256 = "01rr8n99mas5x0vfxh8wf01vbh29vil860waxnsn6xdqc9fm5jj2";
  buildDepends = [ stm wxcore ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
