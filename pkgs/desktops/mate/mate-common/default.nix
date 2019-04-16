{ stdenv, fetchurl, mate }:

stdenv.mkDerivation rec {
  name = "mate-common-${version}";
  version = "1.20.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "0h8s2qhc6f5flslx05cd3xxg243c67vv03spjiag14p8kqqrqvb1";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
