{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mate-common-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.17";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "06pvbi2kk39ysd9dfi6ljkncm53hn02n7dygax6ig4p9qd750sdc";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
