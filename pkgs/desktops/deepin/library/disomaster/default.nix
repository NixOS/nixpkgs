{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  libsForQt5,
  libisoburn,
}:

stdenv.mkDerivation rec {
  pname = "disomaster";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-wN8mhddqqzYXkT6rRWsHVCWzaG2uRcF2iiFHlZx2LfY=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qttools
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [ libisoburn ];

  qmakeFlags = [ "VERSION=${version}" ];

  meta = with lib; {
    description = "Libisoburn wrapper class for Qt";
    homepage = "https://github.com/linuxdeepin/disomaster";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
