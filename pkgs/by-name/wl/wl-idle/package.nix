{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "wl-idle";
  version = "0-unstable-2024-03-11";

  src = fetchFromGitHub {
    owner = "suzumenobu2";
    repo = "wl-idle";
    rev = "e814f73a229fbb0a1e25b0d4d3947646365de104";
    hash = "sha256-13EdEpCnvVrTuBJVIFxR6sbFWUELgX5nDbI6egeR/OA=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-d5OviYSAW9HFsWzO2Z+XRXsrfOhCdZLwArQrXWiypNI=";
  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch=main" ]; };

  meta = {
    description = "Simple idle daemon for wayland using the ext_idle_notify_v1 protocol";
    homepage = "https://github.com/suzumenobu2/wl-idle";
    license = lib.licenses.unfree; # Currently not licensed, all rights reserved
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "wl-idle";
  };
}
