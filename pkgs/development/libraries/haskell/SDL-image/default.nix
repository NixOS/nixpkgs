{ cabal, SDL, SDL_image }:

cabal.mkDerivation (self: {
  pname = "SDL-image";
  version = "0.6.1";
  sha256 = "18n6al40db7xalqqr4hp0l26qxxv1kmd8mva0n7vmhg05zypf6ni";
  buildDepends = [ SDL ];
  extraLibraries = [ SDL_image ];
  meta = {
    description = "Binding to libSDL_image";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
