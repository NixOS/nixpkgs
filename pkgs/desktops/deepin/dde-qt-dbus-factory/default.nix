{ stdenv
, fetchFromGitHub
, qmake
, python3
, deepin
}:

stdenv.mkDerivation rec {
  pname = "dde-qt-dbus-factory";
  version = "5.1.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1bfl8dhm5ms93kxlfdvn08ax8h7ab64z8hsdfdrn86mwhlkvm1lq";
  };

  nativeBuildInputs = [
    qmake
    python3
    deepin.setupHook
  ];

  postPatch = ''
    searchHardCodedPaths
    fixPath $out /usr \
      libdframeworkdbus/DFrameworkdbusConfig.in \
      libdframeworkdbus/libdframeworkdbus.pro
  '';

  qmakeFlags = [
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Qt DBus interface library for Deepin software";
    homepage = "https://github.com/linuxdeepin/dde-qt-dbus-factory";
    license = with licenses; [ gpl3Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
