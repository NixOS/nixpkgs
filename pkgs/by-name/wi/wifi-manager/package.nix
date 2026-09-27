{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  gtk4-layer-shell,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wifi-manager";
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "Vijay-papanaboina";
    repo = "wifi-manager";
    rev = "80f09c6cdc4aa2dc5bc05cd80bc37aca30e5c5a7";
    hash = "sha256-3L9kQJL8hnWNf6B2QmM/n7awvm0e6RtiCOIakDP3bpo=";
  };

  cargoHash = "sha256-CawPC9tkUy1npLmvCL71PzEf0fcJwMsOsIVAHsHwTUk=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    gtk4-layer-shell
  ];

  meta = {
    description = "Lightweight native WiFi manager for Wayland compositors";
    homepage = "https://github.com/Vijay-papanaboina/wifi-manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ imalison ];
    mainProgram = "wifi-manager";
    platforms = lib.platforms.linux;
  };
})
