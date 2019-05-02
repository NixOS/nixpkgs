{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, qtmultimedia,
  qtsvg, qtx11extras, librsvg, libstartup_notification, gsettings-qt,
  dde-qt-dbus-factory, dtkcore, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkwidget";
  version = "2.0.10";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "11a7yirfkcj3rq7va9av4m1pr22mq1yx1j9k18xrqv36n0rlbrr6";
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

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Deepin graphical user interface library";
    homepage = https://github.com/linuxdeepin/dtkwidget;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
