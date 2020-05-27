{ stdenv
, fetchFromGitHub
, qmake
, python3
, deepin
}:

stdenv.mkDerivation rec {
  pname = "dde-qt-dbus-factory";
  version = "5.3.0.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0x45d44i08nvqps299c1hw36qv849g7nks52ggwmk3hg01p7iav2";
  };

  nativeBuildInputs = [
    qmake
    python3
    deepin.setupHook
  ];

  qmakeFlags = [
    "QMAKE_PKGCONFIG_PREFIX=${placeholder "out"}"
  ];

  postPatch = ''
    searchHardCodedPaths
    fixPath $out /usr \
      libdframeworkdbus/DFrameworkdbusConfig.in \
      libdframeworkdbus/libdframeworkdbus.pro
  '';

  postFixup = ''
    searchHardCodedPaths $out
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Qt DBus interface library for Deepin software";
    homepage = "https://github.com/linuxdeepin/dde-qt-dbus-factory";
    license = with licenses; [ gpl3Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
