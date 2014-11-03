{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, flex, bison, libxml2, intltool,
  itstool, python }:

let
  major = "3.13";
  minor = "1";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "anjuta-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/anjuta/${major}/${name}.tar.xz";
    sha256 = "71bdad9a0e427d9481858eec40b9c1facef4b551d732023cc18a50019df4b78b";
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
