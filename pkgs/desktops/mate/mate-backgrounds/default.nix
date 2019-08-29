{ stdenv, fetchurl, intltool }:

stdenv.mkDerivation rec {
  name = "mate-backgrounds-${version}";
  version = "1.22.0";

  src = fetchurl {
    url = "http://pub.mate-desktop.org/releases/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1j9ch04qi2q4mdcvb92w667ra9hpfdf2bfpi1dpw0nbph7r6qvj9";
  };

  nativeBuildInputs = [ intltool ];

  meta = with stdenv.lib; {
    description = "Background images and data for MATE";
    homepage = https://mate-desktop.org;
    license = licenses.gpl2;
    platforms = platforms.unix;
    maintainers = [ maintainers.romildo ];
  };
}
