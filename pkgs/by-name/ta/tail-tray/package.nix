{
  lib,
  fetchFromGitHub,
  davfs2,
  cmake,
  extra-cmake-modules,
  stdenv,
  pkg-config,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "tail-tray";
  version = "0.2.27";

  src = fetchFromGitHub {
    owner = "SneWs";
    repo = "tail-tray";
    tag = "v${version}";
    hash = "sha256-/T7t8I1cfhNmTW277X8lz68qsp2KIDJPxAgUibh6O+w=";
  };

  nativeBuildInputs = with kdePackages; [
    wrapQtAppsHook
    qttools
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = with kdePackages; [
    qtbase
    davfs2
    knotifyconfig
  ];

  cmakeFlags = [
    "-DKNOTIFICATIONS_ENABLED=ON"
    "-DDAVFS_ENABLED=ON"
  ];

  meta = {
    description = "Tray icon to manage Tailscale";
    homepage = "https://github.com/SneWs/tail-tray";
    changelog = "https://github.com/SneWs/tail-tray/releases/tag/${src.tag}";
    mainProgram = "tail-tray";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Svenum ];
    platforms = lib.platforms.linux;
  };
}
