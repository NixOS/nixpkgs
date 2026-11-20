{
  lib,
  rustPlatform,
  cairo,
  fetchFromGitHub,
  nix-update-script,
  pango,
  patchelf,
  pkg-config,
  wayland,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wl-tray-bridge";
  version = "0-unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "mahkoh";
    repo = "wl-tray-bridge";
    rev = "04cb349720f266917b5490e4a02f08d6ddf3f233";
    hash = "sha256-pYmFEqMMEsSTYBwxbD2l2F+lO7WuVt1FFmnkCCoaXf0=";
  };

  cargoHash = "sha256-TM3Jsgmp5idFIOMm+qz0rNEWEhcGeQywF7ZmKlg6CXg=";

  nativeBuildInputs = [
    patchelf
    pkg-config
  ];

  buildInputs = [
    cairo
    pango
  ];

  postFixup = ''
    patchelf --add-rpath ${lib.makeLibraryPath [ wayland ]} $out/bin/wl-tray-bridge
  '';

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Bridges the gap between the StatusNotifierItem protocols and wayland compositors implementing jay-tray-v1";
    homepage = "https://github.com/mahkoh/wl-tray-bridge";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ uku3lig ];
    mainProgram = "wl-tray-bridge";
  };
})
