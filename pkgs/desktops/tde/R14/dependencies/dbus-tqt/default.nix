{ stdenv, fetchurl, pkgconfig, cmake, tde }:

let baseName = "dbus-tqt"; in
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
    sha256 = "05q0i918si3q7z3ghjrzmc6npm2f0arzqh295qm19bl0p6ihncgz";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  propagatedBuildInputs = [ tde.dbus-1-tqt ];

  preConfigure = ''
    cd ${baseName}
  '';

  meta = with stdenv.lib;{
    description = "D-Bus API bindings for TDE";
    homepage = http://www.trinitydesktop.org;
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
