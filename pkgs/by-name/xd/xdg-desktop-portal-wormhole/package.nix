{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  qt6,
  wayland-scanner,
  glib,
  pipewire,
  wayland,
  wayland-protocols,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xdg-desktop-portal-wormhole";
  version = "1.0.2";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "AstraSuite";
    repo = "Wormhole";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NCttrS5eXXuSYNiynu2jTlpt3brPnS8nNJEAQqcXcuI=";
  };

  postPatch = ''
    substituteInPlace src/main.cpp \
      --replace-fail 'app.setApplicationVersion("1.0.0");' 'app.setApplicationVersion("${finalAttrs.version}");'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    wayland-scanner
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtmultimedia
    glib
    pipewire
    wayland
    wayland-protocols
  ];

  cmakeFlags = [
    (lib.cmakeFeature "WORMHOLE_VERSION" finalAttrs.version)
    (lib.cmakeFeature "INIT_SYSTEM" "systemd")
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen wormhole --version";
    };
  };

  meta = {
    description = "XDG Desktop Portal for Caelestia Shell";
    homepage = "https://github.com/AstraSuite/Wormhole";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rachalaraj ];
    mainProgram = "wormhole";
    platforms = lib.platforms.linux;
  };
})
