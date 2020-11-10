{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mate-common";
  version = "1.24.2";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0srb2ly5pjq1g0cs8m39nbfv33dvsc2j4g2gw081xis3awzh3lki";
  };

  enableParallelBuilding = true;

  meta = {
    description = "Common files for development of MATE packages";
    homepage = "https://mate-desktop.org";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
