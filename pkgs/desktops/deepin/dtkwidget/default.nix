{ stdenv, fetchFromGitHub, pkgconfig, qmake, qttools, qtmultimedia,
  qtsvg, qtx11extras, librsvg, libstartup_notification, gsettings-qt,
  dde-qt-dbus-factory, dtkcore, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dtkwidget";
  version = "2.0.12.3";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0z71il09gj1frkxfw3av97szh17spr6ss1k07l0prk1s1wm7yyfr";
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
