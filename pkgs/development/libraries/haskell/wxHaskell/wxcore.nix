{ cabal, libX11, mesa, parsec, stm, time, wxdirect, wxGTK }:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.12.1.7";
  sha256 = "12vs449xg2xjp503ywjwxadan3v7dq38ph66292szwj1vmhl07v4";
  buildDepends = [ parsec stm time wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell core";
    license = "LGPL";
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
