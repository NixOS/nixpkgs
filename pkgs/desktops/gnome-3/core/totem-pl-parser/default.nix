{ stdenv, fetchurl, meson, ninja, pkgconfig, gettext, gmime, libxml2, libsoup, gnome3 }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  nativeBuildInputs = [ meson ninja pkgconfig gettext ];
  buildInputs = [ gmime libxml2 libsoup ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Simple GObject-based library to parse and save a host of playlist formats";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2;
    platforms = platforms.linux;
  };
}
