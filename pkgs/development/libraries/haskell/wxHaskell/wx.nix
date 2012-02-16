{ cabal, stm, wxcore }:

cabal.mkDerivation (self: {
  pname = "wx";
  version = "0.13.2.1";
  sha256 = "0s5jmsrip26ahvz7mzf12m9rcibrk9is3kwbswz87h0sr0k11nbv";
  buildDepends = [ stm wxcore ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
