{ stdenv, fetchurl, pkgconfig, cmake, dbus-1-tqt }:

stdenv.mkDerivation rec{

  name = "dbus-tqt-${version}";
  version = "${majorVer}.${minorVer}";
  majorVer = "R14";
  minorVer = "0.3";

  src = fetchurl {
    url = "mirror://tde/${version}/dependencies/${name}.tar.bz2";
    sha256 = "13l2ah204y5bbp7zpqgpsis3abvpkayqq38r30dnm5nn6vg7d9zb";
  };

  buildInputs = [ pkgconfig cmake ];
  propagatedBuildInputs = [ dbus-1-tqt ];

  preConfigure = "cd dbus-tqt";

  meta = with stdenv.lib;{
    description = "D-Bus API bindings for TDE";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
