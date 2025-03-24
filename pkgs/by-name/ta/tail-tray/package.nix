{
  lib,
  fetchFromGitHub,
  davfs2,
  cmake,
  stdenv,
  pkg-config,
  kdePackages,
}:

stdenv.mkDerivation rec {
  pname = "tail-tray";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "SneWs";
    repo = "tail-tray";
    tag = "v${version}";
    sha256 = "sha256-Q+kethk9JpJCdMnt4qDpzuf8RUq3vpwTq1N8dLTpcpI=";
  };

  nativeBuildInputs = with kdePackages; [
    wrapQtAppsHook
    qttools
    cmake
    pkg-config
  ];

  buildInputs = with kdePackages; [
    qtbase
    davfs2
  ];

  patches = [
    ./desktop.patch
  ];

  meta = {
    description = "Tray icon to manage Tailscale";
    homepage = "https://github.com/SneWs/tail-tray";
    changelog = "https://github.com/SneWs/tail-tray/releases/tag/${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ Svenum ];
    platforms = lib.platforms.linux;
  };
}
