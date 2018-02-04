{ stdenv, fetchurl, intltool }:

stdenv.mkDerivation rec {
  name = "mate-backgrounds-${version}";
  version = "${major-ver}.${minor-ver}";
  major-ver = "1.18";
  minor-ver = "0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${major-ver}/${name}.tar.xz";
    sha256 = "06q8ksjisijps2wn959arywsimhzd3j35mqkr048c26ck24d60zi";
  };

  nativeBuildInputs = [ intltool ];

  meta = with stdenv.lib; {
    description = "Background images and data for MATE";
    homepage = http://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
