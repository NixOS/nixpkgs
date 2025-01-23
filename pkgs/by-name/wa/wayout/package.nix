{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage rec {
  pname = "wayout";
  version = "1.1.3";

  src = fetchFromSourcehut {
    owner = "~shinyzenith";
    repo = pname;
    rev = version;
    sha256 = "sha256-EzRetxx0NojhBlBPwhQ7p9rGXDUBlocVqxcEVGIF3+0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RiM9d/aOCnV0t13QQO1fdw+QPGMoF/EjIDA2uttjXcQ=";

  meta = with lib; {
    description = "Simple output management tool for wlroots based compositors implementing";
    homepage = "https://git.sr.ht/~shinyzenith/wayout";
    license = licenses.bsd2;
    maintainers = with maintainers; [ onny ];
    platforms = platforms.linux;
    mainProgram = "wayout";
  };

}
