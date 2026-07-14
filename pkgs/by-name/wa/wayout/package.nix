{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayout";
  version = "1.1.3";

  src = fetchFromSourcehut {
    owner = "~shinyzenith";
    repo = "wayout";
    rev = finalAttrs.version;
    sha256 = "sha256-EzRetxx0NojhBlBPwhQ7p9rGXDUBlocVqxcEVGIF3+0=";
  };

  cargoHash = "sha256-RiM9d/aOCnV0t13QQO1fdw+QPGMoF/EjIDA2uttjXcQ=";

  meta = {
    description = "Simple output management tool for wlroots based compositors implementing";
    homepage = "https://git.sr.ht/~shinyzenith/wayout";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ onny ];
    platforms = lib.platforms.linux;
    mainProgram = "wayout";
  };

})
