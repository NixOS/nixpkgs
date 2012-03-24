{ cabal, SDL, SDL_ttf }:

cabal.mkDerivation (self: {
  pname = "SDL-ttf";
  version = "0.6.1";
  sha256 = "0n6vbigkjfvvk98bp7ys14snpd1zmbz69ndhhpnrn02h363vwkal";
  buildDepends = [ SDL ];
  extraLibraries = [ SDL_ttf ];
  meta = {
    description = "Binding to libSDL_ttf";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
