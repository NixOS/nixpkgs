{ stdenv, fetchurl, gettext }:

stdenv.mkDerivation rec {
  pname = "mate-backgrounds";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "16rmsy02fyq6mj6xgc5mdyh146z3zmkn7iwsi44s962aqwbpn4i8";
  };

  nativeBuildInputs = [ gettext ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Background images and data for MATE";
    homepage = "https://mate-desktop.org";
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
