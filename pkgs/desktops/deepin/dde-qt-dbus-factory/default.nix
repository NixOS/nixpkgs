{ stdenv, fetchFromGitHub, qmake, python3, deepin }:

stdenv.mkDerivation rec {
  pname = "dde-qt-dbus-factory";
  version = "1.1.5";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1jzfblsmnfpgym95mmbd8mjkk8wqqfb0kz6n6fy742hmqlzrpsj7";
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

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit ;name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Qt DBus interface library for Deepin software";
    homepage = https://github.com/linuxdeepin/dde-qt-dbus-factory;
    license = with licenses; [ gpl3Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
