{
  lib,
  fetchFromGitHub,
  fetchpatch,
  davfs2,
  cmake,
  extra-cmake-modules,
  stdenv,
  pkg-config,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "tail-tray";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "SneWs";
    repo = "tail-tray";
    tag = "v${version}";
    hash = "sha256-fnr7EheVG3G4oLAe9liAy5qCDED/7eL0mUiE0qXsco4=";
  };

  patches = [
    # https://github.com/SneWs/tail-tray/pull/82
    (fetchpatch {
      name = "dont-use-absoulte-paths-in-desktop-file.patch";
      url = "https://github.com/SneWs/tail-tray/commit/08aa4a4e061f21c2dcd07c94249f2eb15c4e4416.patch";
      hash = "sha256-6YOJes40e2rgVabYns55M5h1FGyFG+gjSewCaXesT8U=";
    })
  ];

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
