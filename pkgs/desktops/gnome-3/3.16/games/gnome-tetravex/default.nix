{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, libxml2, intltool, itstool }:

stdenv.mkDerivation rec {
  name = "gnome-tetravex-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-tetravex/${gnome3.version}/${name}.tar.xz";
    sha256 = "07cmcmrd5fj8vm682894gra2vj8jwx01n3ggjinl93yv4gwpplz9";
  };

  buildInputs = [
    pkgconfig gtk3 wrapGAppsHook intltool itstool libxml2 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Tetravex;
    description = "Complete the puzzle by matching numbered tiles";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
