{cabal, SDL, SDL_image}:

cabal.mkDerivation (self : {
  pname = "SDL-image";
  version = "0.5.2";
  sha256 = "82765f5ed11ef2ad3eb47f59105fe5aecd8de2515d698ef9ea989dc4cec18016";
  propagatedBuildInputs = [SDL SDL_image];
  meta = {
    description = "Binding to libSDL_image";
  };
})

