{ cabal, Cabal, filepath, libX11, mesa, parsec, stm, time, wxdirect
, wxGTK
}:

cabal.mkDerivation (self: {
  pname = "wxcore";
  version = "0.13.2.1";
  sha256 = "0p0d9vxw2pyvnhswsgasdd62hj86w3ixbbsx41wkswzkjjjib9i6";
  buildDepends = [ Cabal filepath parsec stm time wxdirect ];
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
