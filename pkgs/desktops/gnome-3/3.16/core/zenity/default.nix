{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, itstool }:

stdenv.mkDerivation rec {

  versionMajor = "3.14";
  versionMinor = "0";

  name = "zenity-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${versionMajor}/${name}.tar.xz";
    sha256 = "0bw95d6ns67h0mw90qcbhxvhbglbpgd66vinvha7gwba8mnfqmvb";
  };

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
	maintainers = [ maintainers.lethalman ];
  };
}
