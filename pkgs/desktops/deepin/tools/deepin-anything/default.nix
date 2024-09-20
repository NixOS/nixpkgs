{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  wrapQtAppsHook,
  udisks2-qt5,
  util-linux,
  libnl,
  glib,
  pcre,
}:

stdenv.mkDerivation rec {
  pname = "deepin-anything";
  version = "6.1.9";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = "deepin-anything";
    rev = version;
    hash = "sha256-OYPsUXMjuU6gG+EzyYl640+2/59n8D5V906CVGwn6Bo=";
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
    wrapQtAppsHook
  ];

  buildInputs = [
    udisks2-qt5
    util-linux
    libnl
    glib
    pcre
  ];

  meta = {
    description = "Deepin Anything file search tool";
    homepage = "https://github.com/linuxdeepin/deepin-anything";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
