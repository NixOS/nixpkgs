{ stdenv, fetchurl, cmake, extra-cmake-modules, pkgconfig, plasma-framework, qtbase, qtquickcontrols2 }:

stdenv.mkDerivation rec {
  pname = "kirigami";
  version = "1.90.0";
  name = "${pname}2-${version}";

  src = fetchurl {
    url = "mirror://kde/unstable/${pname}/${pname}-${version}.tar.xz";
    sha256 = "a5ca094a60d1cc48116cbed07bbe68be016773d2488a91e278859c90f59e64a8";
  };

  buildInputs = [ qtbase qtquickcontrols2 plasma-framework ];

  nativeBuildInputs = [ cmake pkgconfig extra-cmake-modules ];

  meta = with stdenv.lib; {
    license = licenses.lgpl2;
    homepage = http://www.kde.org;
    maintainers = with maintainers; [ ttuegel peterhoeg ];
    platforms = platforms.unix;
    broken = builtins.compareVersions qtbase.version "5.7.0" < 0;
  };
}
