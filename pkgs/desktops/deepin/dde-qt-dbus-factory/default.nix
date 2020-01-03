{ stdenv, fetchFromGitHub, qmake, python3, deepin }:

stdenv.mkDerivation rec {
  pname = "dde-qt-dbus-factory";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1wbh4jgvy3c09ivy0vvfk0azkg4d2sv37y23c9rq49jb3sakcjgm";
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

  passthru.updateScript = deepin.updateScript { name = "${pname}-${version}"; };

  meta = with stdenv.lib; {
    description = "Qt DBus interface library for Deepin software";
    homepage = https://github.com/linuxdeepin/dde-qt-dbus-factory;
    license = with licenses; [ gpl3Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
