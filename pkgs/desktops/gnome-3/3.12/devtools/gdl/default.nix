{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, intltool }:

let
  major = "3.12";
  minor = "0";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "gdl-${version}";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gdl/${major}/${name}.tar.xz";
    sha256 = "4770f959f31ed5e616fe623c284e8dd6136e49902d19b6e37938d34be4f6b88d";
  };

  buildInputs = [ pkgconfig libxml2 gtk3 intltool ];

  meta = with stdenv.lib; {
    description = "Gnome docking library";
    homepage = https://developer.gnome.org/gdl/;
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
