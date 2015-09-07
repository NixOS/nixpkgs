{ stdenv, fetchurl, pkgconfig, libxml2, gtk3, gnome3, intltool }:

let
  major = gnome3.version;
  minor = "0";

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "gdl-${version}";

  src = fetchurl {
    url = "https://download.gnome.org/sources/gdl/${major}/${name}.tar.xz";
    sha256 = "107zwvs913jr5hb59a4a8hsk19yinsicr2ma4vm216nzyl2f3jrl";
  };

  buildInputs = [ pkgconfig libxml2 gtk3 intltool ];

  meta = with stdenv.lib; {
    description = "Gnome docking library";
    homepage = https://developer.gnome.org/gdl/;
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
