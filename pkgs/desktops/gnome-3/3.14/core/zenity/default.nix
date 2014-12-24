{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, itstool }:

stdenv.mkDerivation rec {

  versionMajor = gnome3.version;
  versionMinor = "0";

  name = "zenity-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${versionMajor}/${name}.tar.xz";
    sha256 = "6b57ec6c456af17714dc366e63dabb8bbe0577878b61907805f0186d4d2b892f";
  };

  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 itstool ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
	maintainers = [ maintainers.lethalman ];
  };
}
