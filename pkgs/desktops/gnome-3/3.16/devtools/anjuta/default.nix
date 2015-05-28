{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, flex, bison, libxml2, intltool,
  itstool, python, makeWrapper }:

let
  major = gnome3.version;
  minor = "0";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "anjuta-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/anjuta/${major}/${name}.tar.xz";
    sha256 = "0g4lv6rzkwfz2wp4fg97qlbvyfh2k9gl7k7lidazaikvnc0jlhvp";
  };

  enableParallelBuilding = true;

  buildInputs = [ pkgconfig flex bison gtk3 libxml2 gnome3.gjs gnome3.gdl
    gnome3.libgda gnome3.gtksourceview intltool itstool python makeWrapper ];

  preFixup = ''
    wrapProgram $out/bin/anjuta \
      --prefix XDG_DATA_DIRS : \
        "$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    description = "Software development studio";
    homepage = http://anjuta.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
