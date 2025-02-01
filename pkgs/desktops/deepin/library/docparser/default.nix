{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  qmake,
  qttools,
  wrapQtAppsHook,
  poppler,
  pugixml,
  libzip,
  libuuid,
  tinyxml-2,
}:

stdenv.mkDerivation rec {
  pname = "docparser";
  version = "1.0.11";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-shZXhs9ncgm6rECvCWrLi26RO1WAc1gRowoYmeKesfk=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    poppler
    pugixml
    libzip
    libuuid
    tinyxml-2
  ];

  qmakeFlags = [ "VERSION=${version}" ];

  meta = {
    description = "Document parser library ported from document2html";
    homepage = "https://github.com/linuxdeepin/docparser";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}
