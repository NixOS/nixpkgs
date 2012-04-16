{ cabal, libX11, mesa, wxdirect, wxGTK }:

cabal.mkDerivation (self: {
  pname = "wxc";
  version = "0.90.0.2";
  sha256 = "1vqs9517qacm04d2bxpbpcdgfmlhpblm6af45nmcdikvlfa1v0jp";
  buildDepends = [ wxdirect ];
  extraLibraries = [ libX11 mesa wxGTK ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/WxHaskell";
    description = "wxHaskell C++ wrapper";
    license = "unknown";
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
