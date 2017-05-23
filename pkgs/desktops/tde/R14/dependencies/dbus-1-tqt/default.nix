{ stdenv, fetchurl, cmake, pkgconfig
, dbus, tde }:

let baseName = "dbus-1-tqt"; in
with stdenv.lib;
stdenv.mkDerivation rec {

  name = "${baseName}-${version}";
  srcName = "${baseName}-R${version}";
  version = "${majorVer}.${minorVer}.${patchVer}";
  majorVer = "14";
  minorVer = "0";
  patchVer = "4";

  src = fetchurl {
    url = "mirror://tde/R${version}/dependencies/${srcName}.tar.bz2";
    sha256 = "1l96pw9nj47qgv2gkc5khi5zgpj3jhf3nv1ir55harcq9nspq6ri";
  };
  
  nativeBuildInputs = [ cmake pkgconfig ];
  propagatedBuildInputs = [ dbus tde.tqtinterface ];

  preConfigure = ''
    cd ${baseName}
  '';

  meta = with stdenv.lib;{
    description = "A backport of Harald Fernengel's Qt4 D-bus bindings";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
