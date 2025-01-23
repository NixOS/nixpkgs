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

  useFetchCargoVendor = true;
  cargoHash = "sha256-WnEIzcdgX5mFF2/GHykV5ATlr8lSqblvmbv1NnOEaiU=";

  meta = with lib; {
    description = "Execute a program when a Wayland compositor reports being N seconds idle";
    homepage = "https://git.sr.ht/~whynothugo/wayidle";
    license = licenses.isc;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "wayidle";
    platforms = platforms.linux;
  };
}
