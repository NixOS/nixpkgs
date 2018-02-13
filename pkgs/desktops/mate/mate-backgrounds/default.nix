{ stdenv, fetchurl, intltool, mate }:

stdenv.mkDerivation rec {
  name = "mate-backgrounds-${version}";
  version = "1.18.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${mate.getRelease version}/${name}.tar.xz";
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
