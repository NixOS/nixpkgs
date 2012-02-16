{ cabal, Cabal, libX11, libXext, libXinerama, syb }:

cabal.mkDerivation (self: {
  pname = "X11";
  version = "1.5.0.1";
  sha256 = "0s8k3lhvlks6i1mwfnm5fimfd2f0sjw9k2p67is3x564kih7mh19";
  buildDepends = [ Cabal syb ];
  extraLibraries = [ libX11 libXext libXinerama ];
  meta = {
    homepage = "https://github.com/haskell-pkg-janitors/X11";
    description = "A binding to the X11 graphics library";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
