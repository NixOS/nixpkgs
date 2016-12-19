{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mate-common-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.16";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "02pj5ry3c7p5sd2mp9dsshy0ij0xgv00bxr4vvmnm027hv2silrl";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
