{ stdenv, fetchFromGitHub, pkgconfig, qmake, python }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "dde-qt-dbus-factory";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "0j0f57byzlz2ixgj6qr1pda83bpwn2q8kxv4i2jv99n6g0qw4nmw";
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

  meta = with stdenv.lib; {
    description = "Qt DBus interface library for Deepin software";
    homepage = https://github.com/linuxdeepin/dde-qt-dbus-factory;
    license = with licenses; [ gpl3Plus lgpl2Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
