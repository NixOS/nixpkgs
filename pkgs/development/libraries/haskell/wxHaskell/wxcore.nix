{ cabal, filepath, libX11, mesa, parsec, stm, time, wxc, wxdirect
, wxGTK
}:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.90.0.3";
  sha256 = "0d79hr6cz9zj3w57h6630nfnsmfq1w73gz04jjmlhwh8ih557imw";
  buildDepends = [ filepath parsec stm time wxc wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell core";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
