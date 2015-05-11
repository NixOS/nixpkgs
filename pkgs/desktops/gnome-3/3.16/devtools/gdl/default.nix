{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, gnome3, intltool }:

let
  major = gnome3.version;
  minor = "0";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "gdl-${version}";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gdl/${major}/${name}.tar.xz";
    sha256 = "4b903c28a8894a82b997a1732a443c8b1d6a510304b3c3b511023339ff5d01db";
  };

  buildInputs = [ pkgconfig libxml2 gtk3 intltool ];

  meta = with stdenv.lib; {
    description = "Gnome docking library";
    homepage = https://developer.gnome.org/gdl/;
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
