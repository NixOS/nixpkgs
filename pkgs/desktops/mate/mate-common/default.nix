{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "mate-common-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.15";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "1r3c0i03ylrlibn4pz4j9qzbnj7b540hyhf98kkzzh680jn59iiy";
  };

  meta = {
    description = "Common files for development of MATE packages";
    homepage = "http://mate-desktop.org";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.romildo ];
  };
}
