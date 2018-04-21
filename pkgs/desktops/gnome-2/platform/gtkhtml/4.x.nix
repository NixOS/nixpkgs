{ stdenv, fetchurl, pkgconfig, gtk3, intltool,
GConf, enchant, isocodes, gnome_icon_theme, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  version = "4.10.0";
  name = "gtkhtml-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/4.10/${name}.tar.xz";
    sha256 = "1hq6asgb5n9q3ryx2vngr4jyi8lg65lzpnlgrgcwayiczcj68fya";
  };

  propagatedBuildInputs = [ gsettings-desktop-schemas gtk3 gnome_icon_theme GConf ];
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool enchant isocodes ];
}
