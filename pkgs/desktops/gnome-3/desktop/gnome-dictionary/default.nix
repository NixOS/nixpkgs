{ stdenv, fetchurl, pkgconfig, gnome3, gnome_doc_utils, intltool, which
, libxml2, libxslt, itstool }:

stdenv.mkDerivation rec {
  version = "3.10.0";
  name = "gnome-dictionary-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-dictionary/3.10/${name}.tar.xz";
    sha256 = "1mqf6ln0cgrw12n9fg81sjbhavrgzvvq7fy3gl55il7pa3z612r5";
  };

  buildInputs = [ gnome3.gtk ];
  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which libxml2 libxslt itstool ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
  };

}
