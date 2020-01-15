{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mate-common";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "11lwckndizawbq993ws8lqp59vsc873zri0m8s1i5zyc4qx9f69z";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = https://mate-desktop.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
