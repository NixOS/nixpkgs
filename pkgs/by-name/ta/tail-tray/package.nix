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
  version = "0.2.22";

  src = fetchFromGitHub {
    owner = "SneWs";
    repo = "tail-tray";
    tag = "v${version}";
    sha256 = "sha256-1tYuZBJFIGwub3wJR/Ms1Dybhn3KMzKYrpgzZEXwqWU=";
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

  patches = [
    ./desktop.patch
  ];

  meta = {
    description = "Tray icon to manage Tailscale";
    homepage = "https://github.com/SneWs/tail-tray";
    changelog = "https://github.com/SneWs/tail-tray/releases/tag/${version}";
    mainProgram = "tail-tray";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Svenum ];
    platforms = lib.platforms.linux;
  };
}
