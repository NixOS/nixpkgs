{
  lib,
  rustPlatform,
  fetchFromSourcehut,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wayidle";
  version = "1.0.1";

  src = fetchFromSourcehut {
    owner = "~whynothugo";
    repo = "wayidle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VZfoPD9bpHOQBtDBpG4My7/KJNTKcy5PjFNO2xKmqKg=";
  };

  cargoHash = "sha256-rpmMUrVobYa9mGERJnhGsvebzWbuL+51VeuXKUIFdwg=";

  meta = with lib; {
    description = "Execute a program when a Wayland compositor reports being N seconds idle";
    homepage = "https://git.sr.ht/~whynothugo/wayidle";
    license = licenses.isc;
    maintainers = [ ];
    mainProgram = "wayidle";
    platforms = platforms.linux;
  };
})
