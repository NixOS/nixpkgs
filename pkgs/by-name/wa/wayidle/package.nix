{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage rec {
  pname = "wayidle";
  version = "1.0.0";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "wayidle";
    rev = "v${version}";
    hash = "sha256-DgsktRIGWswSBYeij5OL4nJwWaURv+v+qzOdZnLKG/E=";
  };

  cargoHash = "sha256-fJXI2y+kUIAwW6QrMf/T/2N6v/OY9BD3g9oXwB7U4so=";

  meta = with lib; {
    description = "Execute a program when a Wayland compositor reports being N seconds idle";
    homepage = "https://git.sr.ht/~whynothugo/wayidle";
    license = licenses.isc;
    maintainers = with maintainers; [ tomfitzhenry ];
    mainProgram = "wayidle";
    platforms = platforms.linux;
  };
}
