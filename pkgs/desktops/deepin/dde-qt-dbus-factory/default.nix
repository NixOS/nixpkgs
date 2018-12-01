{ stdenv, fetchFromGitHub, pkgconfig, qmake, python3, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-qt-dbus-factory";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0yilhlgdxinwd8bncbzfry40596vaxcdqpcryzr7wj6haxybx0jm";
  };

  nativeBuildInputs = [
    qmake
    python3
    deepin.setupHook
  ];

  postPatch = ''
    searchHardCodedPaths
    patchShebangs .
    fixPath $out /usr \
      libdframeworkdbus/DFrameworkdbusConfig.in \
      libdframeworkdbus/libdframeworkdbus.pro
  '';

  enableParallelBuilding = true;

  passthru.updateScript = deepin.updateScript { inherit name; };

  meta = with stdenv.lib; {
    description = "Qt DBus interface library for Deepin software";
    homepage = https://github.com/linuxdeepin/dde-qt-dbus-factory;
    license = with licenses; [ gpl3Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
