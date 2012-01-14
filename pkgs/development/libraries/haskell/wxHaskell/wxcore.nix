{ cabal, libX11, mesa, parsec, stm, time, wxdirect, wxGTK }:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.13.2";
  sha256 = "1kzgqmh0vjm1qcskkfdyjbbq276nhd76w7bgxgdq67zl48bfc09g";
  buildDepends = [ parsec stm time wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell core";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
