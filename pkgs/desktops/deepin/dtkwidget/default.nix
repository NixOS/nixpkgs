{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, qtmultimedia,
  qtsvg, qtx11extras, librsvg, libstartup_notification, gsettings-qt,
  dde-qt-dbus-factory, dtkcore
}:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkwidget";
  version = "2.0.9.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "06iyb3ryxrqkwxdazpv8cgabqa4djldgm3q5icsa2grqrgy8vw5m";
  };

  nativeBuildInputs = [
    pkgconfig
    qmake
    qttools
  ];

  buildInputs = [
    qtmultimedia
    qtsvg
    qtx11extras
    librsvg
    libstartup_notification
    gsettings-qt
    dde-qt-dbus-factory
    dtkcore
  ];

  preConfigure = ''
    qmakeFlags="$qmakeFlags \
      INCLUDE_INSTALL_DIR=$out/include \
      LIB_INSTALL_DIR=$out/lib \
      QT_HOST_DATA=$out"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Deepin graphical user interface library";
    homepage = https://github.com/linuxdeepin/dtkwidget;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
