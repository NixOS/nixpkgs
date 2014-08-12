{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, itstool }:

stdenv.mkDerivation rec {

  versionMajor = "3.8";
  versionMinor = "0";

  name = "zenity-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${versionMajor}/zenity-${versionMajor}.${versionMinor}.tar.xz";
    sha256 = "0gsnwvhsqqba5i6d4jh86j29q4q18hmvhj9c1v76vwlj2nvz1ywl";
  };

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };
}
