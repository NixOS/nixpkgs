{ stdenv, mkDerivation, fetchFromGitHub, pkgconfig, qmake, qttools, qtmultimedia,
  qtsvg, qtx11extras, librsvg, libstartup_notification, gsettings-qt,
  dde-qt-dbus-factory, dtkcore, deepin }:

mkDerivation rec {
  pname = "dtkwidget";
  version = "2.0.14";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "11ws0rl7rhlgwbqd4nqpqxhngf4lcyfrrdq33wzxwdlk33d69i1h";
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

  outRef = placeholder "out";

  qmakeFlags = [
    "INCLUDE_INSTALL_DIR=${outRef}/include"
    "LIB_INSTALL_DIR=${outRef}/lib"
    "QT_HOST_DATA=${outRef}"
  ];

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Deepin graphical user interface library";
    homepage = https://github.com/linuxdeepin/dtkwidget;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
