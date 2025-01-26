{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage rec {
  pname = "wayidle";
  version = "0.2.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "wayidle";
    rev = "v${version}";
    hash = "sha256-7hFk/YGOQ5+gQy6pT5DRgMLThQ1vFAvUvdHekTyzIRU=";
  };

  cargoHash = "sha256-PohfLmUoK+2a7Glnje4Rbym2rvzydUJAYW+edOj7qeo=";

  meta = with lib; {
    description = "Execute a program when a Wayland compositor reports being N seconds idle";
    homepage = "https://git.sr.ht/~whynothugo/wayidle";
    license = licenses.isc;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "wayidle";
    platforms = platforms.linux;
  };
}
