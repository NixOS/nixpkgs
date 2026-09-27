{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-scanner,
  wayland,
  wayland-protocols,
  sdbus-cpp_2,
  systemd,
  pipewire,
  libdrm,
  libgbm,
  cairo,
  tomlplusplus,
  nlohmann_json,
  gtk4,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-umbriel";
  version = "0-unstable-2026-09-24";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "xdg-desktop-portal-umbriel";
    # No tagged releases yet
    rev = "ee380d66984a45310ef48a283ad806ebab752788";
    hash = "sha256-NIjks+J3+GcAUWZxWiFLl/rtNYl/VrlIZOm1PMAO4Ss=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayland
    wayland-protocols
    sdbus-cpp_2
    systemd
    pipewire
    libdrm
    libgbm
    cairo
    tomlplusplus
    nlohmann_json
    gtk4
  ];

  mesonBuildType = "release";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/noctalia-dev/xdg-desktop-portal-umbriel";
    description = "xdg-desktop-portal backend for the Umbriel compositor";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [
      pyrox0
      samiser
    ];
  };
}
