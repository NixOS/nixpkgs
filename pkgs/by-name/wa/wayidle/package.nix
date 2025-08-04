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

  cargoHash = "sha256-rpmMUrVobYa9mGERJnhGsvebzWbuL+51VeuXKUIFdwg=";

  meta = {
    description = "Execute a program when a Wayland compositor reports being N seconds idle";
    homepage = "https://git.sr.ht/~whynothugo/wayidle";
    license = lib.licenses.isc;
    maintainers = [ ];
    mainProgram = "wayidle";
    platforms = lib.platforms.linux;
  };
}
