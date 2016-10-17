{ stdenv, fetchurl, cmake, ecm, pkgconfig, plasma-framework, qtbase, qtquickcontrols }:

stdenv.mkDerivation rec {
  pname = "kirigami";
  version = "1.1.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://kde/stable/${pname}/${name}.tar.xz";
    sha256 = "1p9ydggwbyfdgwmvyc8004sk9mfshlg9b83lzvz9qk3a906ayxv6";
  };

  buildInputs = [ qtbase qtquickcontrols plasma-framework ];

  nativeBuildInputs = [ cmake pkgconfig ecm ];

  meta = with stdenv.lib; {
    license = licenses.lgpl2;
    homepage = http://www.kde.org;
    maintainers = with maintainers; [ ttuegel peterhoeg ];
    platforms = platforms.unix;
  };
}
