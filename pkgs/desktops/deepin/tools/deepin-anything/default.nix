{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  udisks2-qt5,
  util-linux,
  libnl,
  glib,
  pcre,
}:

stdenv.mkDerivation rec {
  pname = "deepin-anything";
  version = "6.2.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-anything";
    rev = version;
    hash = "sha256-eGel+pLAYHYkPXQxzTz+lMPSlgNiDFAev2bzGjj4ZFw=";
  };

  postPatch = ''
    substituteInPlace src/CMakeLists.txt \
      --replace-fail 'add_subdirectory("kernelmod")' " "
    substituteInPlace src/server/backend/CMakeLists.txt \
      --replace-fail "/usr" "$out" \
      --replace-fail "/etc" "$out/etc"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    udisks2-qt5
    util-linux
    libnl
    libsForQt5.polkit-qt
    glib
    pcre
  ];

  meta = {
    description = "Deepin Anything file search tool";
    homepage = "https://github.com/linuxdeepin/deepin-anything";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.deepin ];
  };
}
