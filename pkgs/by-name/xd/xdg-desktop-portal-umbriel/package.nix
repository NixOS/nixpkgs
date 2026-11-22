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
  libglvnd,
  libxkbcommon,
  freetype,
  fontconfig,
  pango,
  harfbuzz,
  glib,
  stb,
  libei,
  dbus,
  autoAddDriverRunpath,
  unstableGitUpdater,
}:
stdenv.mkDerivation {
  pname = "xdg-desktop-portal-umbriel";
  version = "0-unstable-2026-11-18";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "noctalia-dev";
    repo = "xdg-desktop-portal-umbriel";
    # No tagged releases yet
    rev = "32b8ee4ff0675c3f819c13b3f4b8651c1b887a43";
    hash = "sha256-7VbiRCkqW8buIC7YXzWHnoS0w4qVUwbxlcsrA2OsvUU=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    autoAddDriverRunpath
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
    libglvnd
    libxkbcommon
    freetype
    fontconfig
    pango
    harfbuzz
    glib
    stb
  ];

  mesonBuildType = "release";

  doCheck = true;
  checkInputs = [ libei ];
  nativeCheckInputs = [ dbus ];

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
