{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mate-common";
  version = "1.24.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "06w25mk2w7rfnkwpnav8pcrvip1zdd0zd1qc6d975ksmg66r1vz7";
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
