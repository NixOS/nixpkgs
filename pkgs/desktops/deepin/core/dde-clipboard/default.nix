{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, gio-qt
, cmake
, extra-cmake-modules
, qttools
, wayland
, kwayland
, dwayland
, pkg-config
, wrapQtAppsHook
, glibmm
, gtest
}:

stdenv.mkDerivation rec {
  pname = "dde-clipboard";
  version = "6.0.7";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-6CbCor0vgVMsMt8KY2uWrNqOsBEIaz7s2nViiHz+m1g=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    gio-qt
    wayland
    kwayland
    dwayland
    glibmm
    gtest
  ];

  cmakeFlags = [
    "-DSYSTEMD_USER_UNIT_DIR=${placeholder "out"}/lib/systemd/user"
  ];

  meta = with lib; {
    description = "DDE optional clipboard manager componment";
    homepage = "https://github.com/linuxdeepin/dde-clipboard";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
