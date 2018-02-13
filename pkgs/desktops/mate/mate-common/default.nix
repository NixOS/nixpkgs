{ stdenv, fetchurl, mate }:

stdenv.mkDerivation rec {
  name = "mate-common-${version}";
  version = "1.18.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
    sha256 = "1005laf3z1h8qczm7pmwr40r842665cv6ykhjg7r93vldra48z6p";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = http://mate-desktop.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
