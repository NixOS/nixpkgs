{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  pname = "ctpl";
  version = "0.3.4";

  src = fetchurl {
    url = "https://download.tuxfamily.org/ctpl/releases/ctpl-${version}.tar.gz";
    sha256 = "1yr92xv9n6kgyixwg9ps4zb404ic5pgb171k4bi3mv9p6k8gv59s";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib ];

  meta = with stdenv.lib; {
    homepage = http://ctpl.tuxfamily.org/;
    description = "Template engine library written in C";
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
    license = licenses.gpl3Plus;
  };
}
