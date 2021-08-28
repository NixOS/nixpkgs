{ stdenv, fetchurl, pkg-config, gtk3, intltool
, GConf, enchant, isocodes, gnome-icon-theme, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  version = "4.10.0";
  pname = "gtkhtml";

  src = fetchurl {
    url = "mirror://gnome/sources/gtkhtml/4.10/${pname}-${version}.tar.xz";
    sha256 = "1hq6asgb5n9q3ryx2vngr4jyi8lg65lzpnlgrgcwayiczcj68fya";
  };

  propagatedBuildInputs = [ gsettings-desktop-schemas gtk3 gnome-icon-theme GConf ];
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ intltool enchant isocodes ];
}
