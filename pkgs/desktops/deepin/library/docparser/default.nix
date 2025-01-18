{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  poppler,
  pugixml,
  libzip,
  libuuid,
  libxml2,
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
    libsForQt5.qmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    poppler
    pugixml
    libzip
    libuuid
    libxml2
    tinyxml-2
  ];

  qmakeFlags = [ "VERSION=${version}" ];

  meta = with lib; {
    description = "Document parser library ported from document2html";
    homepage = "https://github.com/linuxdeepin/docparser";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
