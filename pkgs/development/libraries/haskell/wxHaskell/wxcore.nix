{ cabal, filepath, libX11, mesa, parsec, stm, time, wxc, wxdirect
, wxGTK
}:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.90.0.1";
  sha256 = "031947805bjw32f1a8w2ra8714ysq5k0pxp11cr9hgcc93l9f3pq";
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
