{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mate-common";
  version = "1.24.1";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1dgp6k2l6dz7x2lnqk4y5xfkld376726hda3mrc777f821kk99nr";
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
