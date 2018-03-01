{ stdenv, fetchurl, pkgconfig, glib, gtk3, enchant, isocodes, vala, gobjectIntrospection, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  propagatedBuildInputs = [ enchant ]; # required for pkgconfig

  nativeBuildInputs = [ pkgconfig vala gobjectIntrospection ];
  buildInputs = [ glib gtk3 isocodes ];

  meta = with stdenv.lib; {
    description = "A spell-checking library for GTK+ applications";
    homepage = https://wiki.gnome.org/Projects/gspell;
    license = licenses.lgpl21Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
