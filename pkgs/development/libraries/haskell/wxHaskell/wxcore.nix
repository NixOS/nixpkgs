{ cabal, filepath, libX11, mesa, parsec, stm, time, wxc, wxdirect
, wxGTK
}:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.90.1.0";
  sha256 = "0pyh5xc8f3rlyn66dawlijwym8nwac12qwh96hfkna0pbqg0995c";
  buildDepends = [ filepath parsec stm time wxc wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  preConfigure = "find . -type f -exec touch {} +";
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell core";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
