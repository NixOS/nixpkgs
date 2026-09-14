{
  lib,
  stdenv,
  fetchFromCodeberg,
  cmake,
  libffi,
  pkg-config,
  wayland,
  wayland-protocols,
  wayland-scanner,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayland-colorbar";
  version = "0.1.1";

  src = fetchFromCodeberg {
    owner = "Pandapip1";
    repo = "wayland-colorbar";
    tag = finalAttrs.version;
    hash = "sha256-QaJWx5/DkxSc53BFufJwxYwwsJNSV2mYV5EjbFDmx3c=";
  };

  __structuredAttrs = true;
  strictDeps = true;
  separateDebugInfo = true;
  nativeBuildInputs = [
    cmake
    pkg-config
    wayland-scanner
  ];
  buildInputs = [
    libffi
    wayland
    wayland-protocols
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A simple wayland client that can be used for testing";
    homepage = "https://codeberg.org/Pandapip1/wayland-colorbar";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ pandapip1 ];
    mainProgram = "wayland-colorbar";
    platforms = lib.platforms.unix;
  };
})
