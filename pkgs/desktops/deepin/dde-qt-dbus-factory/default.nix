{ stdenv, fetchFromGitHub, pkgconfig, qmake, python, deepin }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-qt-dbus-factory";
  version = "1.0.6";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "13q1313dnil6p5fx4x2aa8jxyqmygifh9xwzxvh7chjw3bp8n7fx";
  };

  nativeBuildInputs = [
    qmake
    python
  ];

  postPatch = ''
    sed -i libdframeworkdbus/{DFrameworkdbusConfig.in,libdframeworkdbus.pro} \
      -e "s,/usr,$out,"
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
