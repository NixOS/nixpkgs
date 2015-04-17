{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, flex, bison, libxml2, intltool,
  itstool, python }:

let
  major = gnome3.version;
  minor = "0";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "anjuta-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/anjuta/${major}/${name}.tar.xz";
    sha256 = "b1aac2d4c35891b23c9bc3f168bf2845e02d0a438742478c98e450950d82b5e5";
  };

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig flex bison gtk3 libxml2 gnome3.gjs gnome3.gdl
    gnome3.libgda gnome3.gtksourceview intltool itstool python ];

  meta = with stdenv.lib; {
    description = "Software development studio";
    homepage = http://anjuta.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
