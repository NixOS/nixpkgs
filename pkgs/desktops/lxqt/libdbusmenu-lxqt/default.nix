{ stdenv
, lib
, fetchFromGitHub
, cmake
, qtbase
, wrapQtAppsHook
, gitUpdater
}:

stdenv.mkDerivation rec {
  pname = "libdbusmenu-lxqt";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-fwYvU62NCmJ6HNrOqHPWKDas7LE1XF3squ0CBEFkNkk=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Qt implementation of the DBusMenu protocol";
    homepage = "https://github.com/lxqt/libdbusmenu-lxqt";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
