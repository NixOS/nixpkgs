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
  version = "0-unstable-2026-08-31";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "xdg-desktop-portal-umbriel";
    # No tagged releases yet
    rev = "d996f0c2bd4e8c868c0a143f0c9ce060f3c47ed5";
    hash = "sha256-1mKBFkIO9RA3ERsLo1QZhyvS6bFSjG1lBpegQnPbIUY=";
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
