{ stdenv
, lib
, fetchFromGitHub
, qmake
, pkg-config
, wrapQtAppsHook
, udisks
}:

stdenv.mkDerivation rec {
  pname = "udisks2-qt5";
  version = "5.0.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-WS4fmqEYXi5dkn8RvyJBzy3+r+UgFcGDFFpQlbblLu4=";
  };

  nativeBuildInputs = [ qmake pkg-config wrapQtAppsHook ];

  buildInputs = [ udisks ];

  qmakeFlags = [ "VERSION=${version}" ];

  meta = with lib; {
    description = "UDisks2 D-Bus interfaces binding for Qt5";
    homepage = "https://github.com/linuxdeepin/udisks2-qt5";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
