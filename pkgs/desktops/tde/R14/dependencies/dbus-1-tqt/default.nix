{ stdenv, fetchurl, cmake, pkgconfig, dbus
, tqtinterface }:

stdenv.mkDerivation rec{

  name = "dbus-1-tqt-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14";
  minorVer = "0.3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "1badq4x7lflgdwp8155ljv6f2wr5byy899lpg6ca6s2p3rmd4jjm";
  };
  
  buildInputs = [ cmake pkgconfig ];
  propagatedBuildInputs = [ dbus tqtinterface ];

  preConfigure = "cd dbus-1-tqt";

  meta = with stdenv.lib;{
    description = "A backport of Harald Fernengel's Qt4 D-bus bindings";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTores ];
    platforms = platforms.linux;
  };
}
